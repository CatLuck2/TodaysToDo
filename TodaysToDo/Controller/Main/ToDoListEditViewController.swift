//
//  ToDoListEditViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit
import RealmSwift

class ToDoListEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var todoListTableView: UITableView!
    // 編集中のタスクリスト (途中で破棄できる)
    private var uneditingTodoList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        uneditingTodoList = Array(RealmResults.sharedInstance[0].todoList)

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellForTodoItemID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        uneditingTodoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellForTodoItemID) as! ToDoItemCell
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
            let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: uneditingTodoList]
            let model = ToDoModel(value: newTodoListForRealm)
            realm.add(model, update: .all)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
