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
    private var newItemList: [(CellType, String?)] = [(CellType.input, ""), (CellType.add, nil)]

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "NewToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.newItemcCellID)
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newItemList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch newItemList[indexPath.row].0 {
        case .input:
            let inputCell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellID) as! ToDoItemCell
            return inputCell
        case .add:
            let addCell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.newItemcCellID) as! NewToDoItemCell
            return addCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newItemList[indexPath.row].0 == .add {
            if newItemList.count == 5 {
                newItemList[indexPath.row].0 = .input
            } else {
                newItemList.insert((.input, ""), at: newItemList.count - 1)
            }
            todoListTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if newItemList.count == 2 {
                return
            }
            if newItemList[indexPath.row].0 == .input {
                let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCell
                // textFieldの初期化
                cell.resetTextField()
                newItemList.remove(at: indexPath.row)
                // 入力したテキストを保存
                print(newItemList)
                // .addを含んでいない場合
                if newItemList.contains(where: { $0 == (CellType.add, nil) }) {
                    newItemList.append((CellType.add, nil))
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
            }
            let newTodoListForRealm: [String: Any] = ["toDoList": newTodoList]
            let todoModel = ToDoModel(value: newTodoListForRealm)
            realm.add(todoModel)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
