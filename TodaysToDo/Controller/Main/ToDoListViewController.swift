//
//  ToDoListViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/19.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources

final class ToDoListViewController: UIViewController, UITableViewDragDelegate, UITableViewDropDelegate, UIScrollViewDelegate {


    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var todoListTableView: UITableView!
    @IBOutlet private weak var completeButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!

    private let dispose = DisposeBag()
    private let realm = try! Realm()
    private var limitedNumberOfCell: Int!
    private var frameOfSelectedTextField = CGRect(x: 0, y: 0, width: 0, height: 0)
    private var viewModel: ToDoListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ToDoListViewModel(todoLogicModel: SharedModel.todoListLogicModel)

        // tableView関連
        todoListTableView.isScrollEnabled = false
        todoListTableView.dropDelegate = self
        todoListTableView.dragDelegate = self
        todoListTableView.dragInteractionEnabled = true
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(R.nib.newToDoItemCell)
        todoListTableView.register(R.nib.toDoItemCell)

        // 自動スクロール関連
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        // キーボードが出現
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [self] notification in
                let overlap = viewModel.getOverlapOfKeyboard(notification: notification, frame: frameOfSelectedTextField)
                if overlap >= 0 {
                    scrollView.contentOffset.y = overlap + 50
                }
            }).disposed(by: dispose)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [self] _ in
                // 画面の位置を元に戻す
                scrollView.contentOffset.y = 0
            }).disposed(by: dispose)

        setupToDoListVC()
        setupBarButton()
        setupTableView()
        setupViewModel()
    }

    func setupBarButton() {
        completeButton.rx.tap
            .subscribe(onNext: {
                self.completeButtonAction()
            }).disposed(by: dispose)

        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: dispose)
    }

    private func setupViewModel() {
        viewModel.itemList
            .bind(to: todoListTableView.rx.items) { [self] tableView, row, _ in
                switch viewModel.itemList.value[row].cellType {
                case .input:
                    guard let inputCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.todoItemCell.identifier) as? ToDoItemCell else {               return UITableViewCell() }
                    // textFieldの座標を計算
                    inputCell.todoItemTextField.rx.controlEvent(.editingDidBegin).asDriver()
                        .drive(onNext: { _ in
                            frameOfSelectedTextField = inputCell.todoItemTextField.convert(inputCell.todoItemTextField.frame, to: self.view)
                        }).disposed(by: dispose)
                    // viewModelのitemListへ代入
                    inputCell.todoItemTextField.rx.controlEvent(.editingChanged).asDriver()
                        .drive(onNext: { _ in
                            guard let text = inputCell.todoItemTextField.text else { return }
                            viewModel.itemList.value[row].title = text
                        }).disposed(by: dispose)
                    // フォーカス中のtextFieldを監視
                    inputCell.todoItemTextField.rx.text.asObservable()
                        .subscribe(onNext: { text in
                            guard let text = text else { return }
                            if text.isEmpty { completeButton.isEnabled = false }
                        }).disposed(by: dispose)
                    // 空のtextFieldを監視
                    inputCell.todoItemTextField.rx.controlEvent(.editingDidEnd).asDriver()
                        .drive(onNext: { _ in
                            if viewModel.isThereEmptyTitle() { completeButton.isEnabled = false } else {
                                completeButton.isEnabled = true
                            }
                        }).disposed(by: dispose)
                    inputCell.todoItemTextField.text = viewModel.itemList.value[row].title
                    return inputCell
                case .add:
                    guard let addCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newAddItemCell.identifier) as? NewToDoItemCell else {
                        return UITableViewCell()
                    }
                    return addCell
                }
            }.disposed(by: dispose)
    }

    private func setupTableView() {
        todoListTableView.rx.setDelegate(self)
            .disposed(by: dispose)
        todoListTableView.rx.itemSelected
            .subscribe(onNext: { [self] indexPath in
                todoListTableView.deselectRow(at: indexPath, animated: true)
                if viewModel.itemList.value[indexPath.row].cellType != .add {
                    return
                }
                // 最大要素数は5つ
                // inputが3つ以下でinputセルを追加
                // inputが4つなら、最後尾のinputをaddへ変更
                if viewModel.itemList.value.count < limitedNumberOfCell {
                    viewModel.itemList.insert(model: ToDoListModel(cellType: .input, title: ""), index: indexPath.row)
                }
                if viewModel.itemList.value.count == limitedNumberOfCell {
                    viewModel.itemList.update(model: ToDoListModel(cellType: .input, title: ""), index: indexPath.row)
                }
            }).disposed(by: dispose)

        todoListTableView.rx.itemDeleted
            .subscribe(onNext: { [self] indexPath in
                if viewModel.itemList.value[indexPath.row].cellType == .add {
                    return
                }
                // 要素が[.input, .add]のとき
                if viewModel.itemList.value.count == 2 {
                    return
                }
                let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCell
                // textFieldの初期化
                // セルの再利用でtextFieldの値が残るのを防ぐため
                cell.resetTextField()
                viewModel.itemList.remove(index: indexPath.row)
                // 削除後、CellType.addのセルがあるか
                if viewModel.itemList.value.contains(where: { $0.cellType == .add }) == false {
                    viewModel.itemList.add(model: ToDoListModel(cellType: .add, title: nil))
                }
            }).disposed(by: dispose)
    }

    private func setupToDoListVC() {
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        limitedNumberOfCell = settingsValueOfTask.numberOfTask
        viewModel.setupItemList(limitedNumberOfCell: limitedNumberOfCell)

        if viewModel.getIsEmptyOfDataInRealm() || viewModel.getIsEmptyOfTodoList() {
            self.title = "タスクを追加"
            completeButton.title = "追加"
        } else {
            self.title = "タスクを編集"
            completeButton.title = "更新"
        }
    }

    private func completeButtonAction() {
        // newItemListからテキストを取り出す
        var textFieldValueArray: [String] = []
        for num in 0..<viewModel.itemList.value.count {
            // String?をiflet文でアンラップ
            if let todoItemText = viewModel.itemList.value[num].title {
                textFieldValueArray.append(todoItemText)
            }
        }

        // Realmへ保存する
        // updateを.allや.modifiedと指定しても、他データが消えてしまうので、他データがある時とない時で処理を分けた
        if viewModel.getIsEmptyOfDataInRealm() {
            // 検証用モデルの追加
            viewModel.add(todoList: textFieldValueArray)
        } else {
            // 次回
            viewModel.updateTodoList(todoElement: textFieldValueArray)
        }

        performSegue(withIdentifier: R.segue.toDoListViewController.unwindToMainVCFromToDoListVC, sender: nil)
    }

    // tableViewのデリゲートメソッド
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // 追加用セルのドラッグを禁止
        if viewModel.itemList.value[indexPath.row].cellType == .add {
            return [UIDragItem]()
        } else {
            return [dragItem(for: indexPath)]
        }
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 追加用セルの位置にドロップされないように制限
        if viewModel.itemList.value[proposedDestinationIndexPath.row].cellType == .add {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }

    //: ドラッグしたアイテムを返す
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let text = viewModel.itemList.value[indexPath.row].title
        guard let nsItemProviderWriting = text as NSItemProviderWriting? else {
            return UIDragItem(itemProvider: NSItemProvider(object: "" as NSItemProviderWriting))
        }
        let provider = NSItemProvider(object: nsItemProviderWriting)
        return UIDragItem(itemProvider: provider)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let item = coordinator.items.first,
              let destinationIndexPath = coordinator.destinationIndexPath,
              let sourceIndexPath = item.sourceIndexPath else {
            return
        }

        // tableViewと要素の配列を更新
        tableView.performBatchUpdates({
            // アイテムを操作
            moveItem(sourcePath: sourceIndexPath.row, destinationPath: destinationIndexPath.row)
            // ドラッグ元のセルを削除
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            // ドラッグ先にセルを挿入
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
        }, completion: nil)
        // ドロップのアニメーションを開始
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }

    private func moveItem(sourcePath: Int, destinationPath: Int) {
        // ドラッグ元のアイテムを削除
        var array = viewModel.itemList.value
        let element = array.remove(at: sourcePath)
        // ドラッグ先にアイテムを挿入
        array.insert(element, at: destinationPath)
        viewModel.itemList.accept(array)
    }

}
