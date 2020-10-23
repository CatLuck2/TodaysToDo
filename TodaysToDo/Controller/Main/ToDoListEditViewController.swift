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

    var todoList: Results<ToDoModel>!

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "ToDoItemCellForEdit", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellForEditID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList[0].toDoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellForEditID) as! ToDoItemCellForEdit
        cell.setTodoItemCell(name: todoList[0].toDoList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm()
            try! realm.write {
                todoList[0].toDoList.remove(at: indexPath.row)
            }
            todoListTableView.reloadData()
        }
    }

    @IBAction private func updateTodoItemButton(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        try! realm.write {
            let numberOfCells = todoListTableView.numberOfRows(inSection: 0)
            for row in 0..<numberOfCells {
                let index = IndexPath(row: row, section: 0)
                let cell = self.todoListTableView.cellForRow(at: index) as! ToDoItemCellForEdit
                todoList[0].toDoList[row] = cell.todoItemTextField.text ?? ""
            }
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
