//
//  ToDoListViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/19.
//

import UIKit
import RealmSwift

private enum CellType {
    case input // タスク名を入力するセル
    case add   // inputのセルを追加するセル
}

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate, UIScrollViewDelegate, customCellDelagete {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var todoListTableView: UITableView!

    // ToDoItemCellのデリゲート
    private let notification = NotificationCenter.default
    // .addの要素でテキストがないことを示すためにnilを設置したく、String?、にした
    // (0, 1) = (Cell.Type, String?)
    private var newItemList: [(CellType, String?)]! = []
    private var limitedNumberOfCell: Int!
    private var frameOfSelectedTextField = CGRect(x: 0, y: 0, width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        limitedNumberOfCell = settingsValueOfTask.numberOfTask

        if RealmResults.sharedInstance.isEmpty == true || RealmResults.sharedInstance[0].todoList.isEmpty == true {
            switch limitedNumberOfCell {
            case 1: // 設定数が1
                newItemList = [(CellType.input, "")]
            default: // 設定数が2~5
                if RealmResults.sharedInstance.isEmpty == true || RealmResults.sharedInstance[0].todoList.isEmpty == true {
                    newItemList = [(CellType.input, ""), (CellType.add, nil)]
                } else {
                    for _ in 0...RealmResults.sharedInstance[0].todoList.count - 1 {
                        // todoListの要素数だけ、Inputを生成
                        newItemList.append((CellType.input, ""))
                    }
                    // 最後にAddを追加
                    if limitedNumberOfCell != 5 {
                        newItemList.append((CellType.add, nil))
                    }
                }
            }
        } else {
            switch limitedNumberOfCell {
            case 1: // 設定数が1
                newItemList = [(CellType.input, "")]
            default: // 設定数が2~5
                if RealmResults.sharedInstance.isEmpty == true || RealmResults.sharedInstance[0].todoList.isEmpty == true {
                    newItemList = [(CellType.input, ""), (CellType.add, nil)]
                } else {
                    for _ in 0...RealmResults.sharedInstance[0].todoList.count - 1 {
                        // todoListの要素数だけ、Inputを生成
                        newItemList.append((CellType.input, ""))
                    }
                    // 最後にAddを追加
                    if RealmResults.sharedInstance[0].todoList.count != 5 {
                        newItemList.append((CellType.add, nil))
                    }
                }
            }
        }

        if RealmResults.sharedInstance.isEmpty == false {
            if RealmResults.sharedInstance[0].todoList.isEmpty == false {
                for i in 0...RealmResults.sharedInstance[0].todoList.count - 1 {
                    newItemList[i].1 = RealmResults.sharedInstance[0].todoList[i]
                }
            }
        }

        // tableView関連
        todoListTableView.isScrollEnabled = false
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
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

    /// tableView関連
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newItemList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch newItemList[indexPath.row].0 {
        case .input:
            guard let inputCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.todoItemCell, for: indexPath) else {
                return UITableViewCell()
            }

            // デリゲートを設定
            inputCell.customCellDelegate = self
            // textFieldの値が変更されるたびに呼ばれる
            inputCell.textFieldValueSender = { sender in
                // as! String以外でWarningを消す方法がわからなかった
                self.newItemList[indexPath.row].1 = (sender as! String)
            }
            guard let itemName = newItemList[indexPath.row].1 else {
                return inputCell
            }
            inputCell.todoItemTextField.text = itemName
            return inputCell
        case .add:
            guard let addCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newAddItemCell.identifier) else {
                return UITableViewCell()
            }
            return addCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if newItemList[indexPath.row].0 == .add {
            // 最大要素数は5つ
            // inputが3つ以下でinputセルを追加
            // inputが4つなら、最後尾のinputをaddへ変更
            if newItemList.count < limitedNumberOfCell {
                newItemList.insert((.input, ""), at: indexPath.row)
            }
            if newItemList.count == limitedNumberOfCell {
                newItemList[indexPath.row] = (CellType.input, "")
            }
            todoListTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 対象の要素が.addのとき
        if newItemList[indexPath.row].0 == .add {
            return .none
        }
        // 要素が[.input, .add]のとき
        if newItemList.count == 2 {
            return .none
        }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCell
            // textFieldの初期化
            // セルの再利用でtextFieldの値が残るのを防ぐため
            cell.resetTextField()
            newItemList.remove(at: indexPath.row)
            // 削除後、CellType.addのセルがあるか
            if newItemList.contains(where: { $0 == (CellType.add, nil) }) == false {
                newItemList.append((CellType.add, nil))
            }
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // 追加用セルのドラッグを禁止
        if newItemList[indexPath.row] == (CellType.add, nil) {
            return [UIDragItem]()
        } else {
            return [dragItem(for: indexPath)]
        }
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 追加用セルの位置にドロップされないように制限
        if newItemList[proposedDestinationIndexPath.row] == (CellType.add, nil) {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }

    //: ドラッグしたアイテムを返す
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let text = newItemList[indexPath.row].1
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
        let prefecture = newItemList.remove(at: sourcePath)
        // ドラッグ先にアイテムを挿入
        newItemList.insert(prefecture, at: destinationPath)
    }

    @IBAction private func addTodoItemButton(_ sender: UIBarButtonItem) {
        // タスク未入力の項目があったらアラート
        for num in 0..<newItemList.count {
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
            if let todoItemText = newItemList[num].1 {
                textFieldValueArray.append(todoItemText)
            }
        }

        // Realmへ保存する
        let realm = try! Realm()
        try! realm.write {
            // updateを.allや.modifiedと指定しても、他データが消えてしまうので、他データがある時とない時で処理を分けた
            if RealmResults.sharedInstance.isEmpty == true {
                // 初回
                let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: textFieldValueArray]
                let model = ToDoModel(value: newTodoListForRealm)
                realm.add(model, update: .all)
            } else {
                // 次回
                RealmResults.sharedInstance[0].todoList.removeAll()
                RealmResults.sharedInstance[0].todoList.append(objectsIn: textFieldValueArray)
            }
        }

        performSegue(withIdentifier: R.segue.toDoListViewController.unwindToMainVCFromToDoListVC, sender: nil)
    }

    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
