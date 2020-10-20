//
//  ToDoListAddViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/18.
//

import UIKit
import RealmSwift

class ToDoListAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum CellType {
        case input
        case add
    }

    @IBOutlet weak var todoListTableView: UITableView!

    private var cellTypeList: [CellType] = [CellType.input,
                                            CellType.add]

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "NewToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.newItemcCellID)
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch cellTypeList[indexPath.row] {
        case .input:
            cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellID) as! ToDoItemCell
        case .add:
            cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.newItemcCellID) as! NewToDoItemCell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellTypeList[indexPath.row] == .add {
            if cellTypeList.count == 5 {
                cellTypeList[indexPath.row] = .input
            } else {
                cellTypeList.insert(.input, at: cellTypeList.count - 1)
            }
            todoListTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if cellTypeList == [.input, .add] {
                return
            }
            if cellTypeList[indexPath.row] == .input {
                cellTypeList.remove(at: indexPath.row)
                if !cellTypeList.contains(.add) {
                    cellTypeList.append(.add)
                }
                tableView.reloadData()
                return
            }
        }
    }

    @IBAction func addTodoItemButton(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        try! realm.write {
            var newTodoList: [String] = []
            let numberOfCells = todoListTableView.numberOfRows(inSection: 0)
            for row in 0..<numberOfCells {
                let index = IndexPath(row: row, section: 0)
                if cellTypeList[index.row] == .input {
                    let cell = self.todoListTableView.cellForRow(at: index) as! ToDoItemCell
                    newTodoList.append(cell.todoItemTextField.text!)
                }
            }
            let newTodoListForRealm: [String: Any] = ["toDoList": newTodoList]
            print(newTodoListForRealm)
            let todoModel = ToDoModel(value: newTodoListForRealm)
            realm.add(todoModel)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
