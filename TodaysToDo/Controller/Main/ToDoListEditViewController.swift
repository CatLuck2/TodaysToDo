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
    // MainViewControllerからRealmのデータが渡されるので、privateはなし
    var results: Results<ToDoModel>!

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
