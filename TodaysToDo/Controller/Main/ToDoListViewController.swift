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

final class ToDoListViewController: UIViewController, UITableViewDragDelegate, UITableViewDropDelegate, UIScrollViewDelegate, customCellDelagete {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var todoListTableView: UITableView!
    @IBOutlet private weak var completeButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!

    private let dispose = DisposeBag()
    private let viewModel = ToDoListViewModel()
    private let realm = try! Realm()
    // ToDoItemCellのデリゲート
    private let notification = NotificationCenter.default
    private var limitedNumberOfCell: Int!
    private var frameOfSelectedTextField = CGRect(x: 0, y: 0, width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        completeButton.rx.tap
            .subscribe(onNext: {
                self.completeButtonAction()
            }).disposed(by: dispose)
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: dispose)

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
        notification.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // キーボードが非表示
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupToDoListVC()
        setupTableView()
        setupViewModel()
    }

    private func setupViewModel() {
        viewModel.itemList
            .bind(to: todoListTableView.rx.items) { [self] tableView, row, _ in
                switch viewModel.itemList.value[row].cellType {
                case .input:
                    guard let inputCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.todoItemCell.identifier) as? ToDoItemCell else {
                        return UITableViewCell()
                    }
                    // textFieldの値が変更されるたびに呼ばれる
                    inputCell.textFieldValueSender = { sender in
                        // as! String以外でWarningを消す方法がわからなかった
                        viewModel.itemList.value[row].title = (sender as! String)
                    }
                    guard let itemName = viewModel.itemList.value[row].title else {
                        return inputCell
                    }
                    inputCell.todoItemTextField.text = itemName
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
                todoListTableView.reloadData()
            }).disposed(by: dispose)

        todoListTableView.rx.itemDeleted
            .subscribe(onNext: { [self] indexPath in
                let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCell
                // textFieldの初期化
                // セルの再利用でtextFieldの値が残るのを防ぐため
                cell.resetTextField()
                viewModel.itemList.remove(index: indexPath.row)
                // 削除後、CellType.addのセルがあるか
                if viewModel.itemList.value.contains(where: { $0.cellType == .add }) == false {
                    viewModel.itemList.add(model: ToDoListModel(cellType: .add, title: nil))
                }
                todoListTableView.reloadData()
            }).disposed(by: dispose)
    }

    private func setupToDoListVC() {
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        limitedNumberOfCell = settingsValueOfTask.numberOfTask

        if RealmResults.isEmptyOfDataInRealm || RealmResults.isEmptyOfTodoList {
            var initialItemList = [ToDoListModel(cellType: .input, title: "")]
            if limitedNumberOfCell != 1 {
                initialItemList.append(ToDoListModel(cellType: .add, title: nil))
            }
            viewModel.itemList.accept(initialItemList)
        } else {
            var initialItemList = [ToDoListModel]()
            for _ in 0..<RealmResults.sharedInstance[0].todoList.count {
                // todoListの要素数だけ、Inputを生成
                initialItemList.append(ToDoListModel(cellType: .input, title: ""))
            }
            for i in 0..<RealmResults.sharedInstance[0].todoList.count {
                initialItemList[i].title = RealmResults.sharedInstance[0].todoList[i]
            }
            // 最後にAddを追加
            if RealmResults.sharedInstance[0].todoList.count < limitedNumberOfCell {
                initialItemList.append(ToDoListModel(cellType: .add, title: nil))
            }
            viewModel.itemList.accept(initialItemList)
        }

        if RealmResults.isEmptyOfDataInRealm || RealmResults.isEmptyOfTodoList {
            self.title = "タスクを追加"
            completeButton.title = "追加"
        } else {
            self.title = "タスクを編集"
            completeButton.title = "更新"
        }
    }

    /// キーボード関連
    @objc
    func keyboardWillAppear(_ notification: Notification) {
        // キーボードの情報を取得
        guard let keyboardInfo = notification.userInfo else {
            return
        }
        // キーボードのFrameを取得
        let keyboardFrame = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // textFieldの上端のy
        let screenHeight = UIScreen.main.bounds.height
        let textFieldTopY = screenHeight - keyboardFrame.size.height
        // textFieldの下端のy
        let originY = frameOfSelectedTextField.origin.y
        let height = frameOfSelectedTextField.height
        let textFieldBottomY = originY + height
        // textFieldとキーボードが重なる領域
        let overlap = textFieldBottomY - textFieldTopY
        // 重なってなければ、スクロール
        if overlap >= 0 {
            scrollView.contentOffset.y = overlap + 50
        }
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        // 画面の位置を元に戻す
        scrollView.contentOffset.y = 0
    }

    /// デリゲートメソッド
    func textFieldDidSelected(_ textField: UITextField) {
        frameOfSelectedTextField = textField.convert(textField.frame, to: self.view)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 対象の要素が.addのとき
        if viewModel.itemList.value[indexPath.row].cellType == .add {
            return .none
        }
        // 要素が[.input, .add]のとき
        if viewModel.itemList.value.count == 2 {
            return .none
        }
        return .delete
    }

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

    private func completeButtonAction() {
        // タスク未入力の項目があったらアラート
        for num in 0..<viewModel.itemList.value.count {
            let indexPath = IndexPath(row: num, section: 0)
            // inputのセルだけをチェック
            if let inputCell = self.todoListTableView.cellForRow(at: indexPath) as? ToDoItemCell, let inputCellText = inputCell.todoItemTextField.text {
                if inputCellText.isEmpty {
                    let alert = UIAlertController(title: "エラー", message: "タスク名が未入力の項目があります", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
        }

        // newItemListからテキストを取り出す
        var textFieldValueArray: [String] = []
        let numberOfCell = todoListTableView.numberOfRows(inSection: 0)
        for num in 0..<numberOfCell {
            // String?をiflet文でアンラップ
            if let todoItemText = viewModel.itemList.value[num].title {
                textFieldValueArray.append(todoItemText)
            }
        }

        // Realmへ保存する
        // updateを.allや.modifiedと指定しても、他データが消えてしまうので、他データがある時とない時で処理を分けた
        if RealmResults.isEmptyOfDataInRealm {
            // 初回
            let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: textFieldValueArray]
            let model = ToDoModel(value: newTodoListForRealm)
            try! realm.write {
                realm.add(model, update: .all)
            }
        } else {
            // 次回
            try! realm.write {
                RealmResults.sharedInstance[0].todoList.removeAll()
                RealmResults.sharedInstance[0].todoList.append(objectsIn: textFieldValueArray)
            }
        }

        performSegue(withIdentifier: R.segue.toDoListViewController.unwindToMainVCFromToDoListVC, sender: nil)
    }

}
