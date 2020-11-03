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

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "ToDoItemCellForEdit", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellForEditID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RealmResults.sharedInstance[0].todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellForEditID) as! ToDoItemCellForEdit
        cell.setTodoItemCell(name: RealmResults.sharedInstance[0].todoList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // セルが1つだけの時
        if self.todoListTableView.numberOfRows(inSection: 0) == 1 {
            return .none
        }
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write {
                RealmResults.sharedInstance[0].todoList.remove(at: indexPath.row)
            }
            todoListTableView.reloadData()
        }
    }

    @IBAction private func updateTodoItemButton(_ sender: UIBarButtonItem) {

        // タスク未入力の項目があったらアラート
        for num in 0..<self.todoListTableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: num, section: 0)
            let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCellForEdit
            if cell.todoItemTextField.text!.isEmpty {
                let alert = UIAlertController(title: "エラー", message: "タスク名が未入力の項目があります", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        }

        // タスクリストを更新
        let realm = try! Realm()
        try! realm.write {
            let numberOfCell = todoListTableView.numberOfRows(inSection: 0)
            for num in 0..<numberOfCell {
                let indexPath = IndexPath(row: num, section: 0)
                let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCellForEdit
                RealmResults.sharedInstance[0].todoList[num] = cell.todoItemTextField.text ?? ""
            }
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
