//
//  ToDoListEditViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit
import RealmSwift

private enum CellType {
    case input // タスク名を入力するセル
    case add   // inputのセルを追加するセル
}

class ToDoListEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDropDelegate, UITableViewDragDelegate, UIScrollViewDelegate, customCellDelagete {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var todoListTableView: UITableView!
    // 編集中のタスクリスト (途中で破棄できる)
    private var uneditingTodoList: [String] = []
    private let notification = NotificationCenter.default
    private var frameOfSelectedTextField = CGRect(x: 0, y: 0, width: 0, height: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        uneditingTodoList = Array(RealmResults.sharedInstance[0].todoList)

        todoListTableView.isScrollEnabled = false
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.dropDelegate = self
        todoListTableView.dragDelegate = self
        todoListTableView.dragInteractionEnabled = true
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellForTodoItemID)

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
        uneditingTodoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellForTodoItemID) as! ToDoItemCell
        cell.customCellDelegate = self
        cell.textFieldValueSender = { sender in
            // as! String以外でWarningを消す方法がわからなかった
            self.uneditingTodoList[indexPath.row] = (sender as! String)
        }
        cell.setTodoItemCell(name: uneditingTodoList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // セルが1つだけの時
        if uneditingTodoList.count == 1 {
            return .none
        }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            uneditingTodoList.remove(at: indexPath.row)
            todoListTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        [dragItem(for: indexPath)]
    }

    //: ドラッグしたアイテムを返す
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let text = uneditingTodoList[indexPath.row]
        let provider = NSItemProvider(object: text as NSItemProviderWriting)
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
        let prefecture = uneditingTodoList.remove(at: sourcePath)
        // ドラッグ先にアイテムを挿入
        uneditingTodoList.insert(prefecture, at: destinationPath)
    }

    @IBAction private func updateTodoItemButton(_ sender: UIBarButtonItem) {

        // タスク未入力の項目があったらアラート
        for num in 0..<uneditingTodoList.count where uneditingTodoList[num].isEmpty {
            let alert = UIAlertController(title: "エラー", message: "タスク名が未入力の項目があります", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        // タスクリストを更新
        let realm = try! Realm()
        try! realm.write {
            RealmResults.sharedInstance[0].todoList.removeAll()
            RealmResults.sharedInstance[0].todoList.append(objectsIn: uneditingTodoList)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
