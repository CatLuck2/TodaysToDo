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
        todoListTableView.register(UINib(nibName: "ToDoItemCellForAdd", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellForAddID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newItemList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch newItemList[indexPath.row].0 {
        case .input:
            let inputCell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellForAddID) as! ToDoItemCellForAdd
            inputCell.textFieldValueSender = { sender in
                self.newItemList[indexPath.row].1 = sender as! String
            }
            guard let textFieldValue = newItemList[indexPath.row].1 else { return inputCell }
            inputCell.todoItemTextField.text = textFieldValue
            return inputCell
        case .add:
            let addCell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.newItemcCellID) as! NewToDoItemCell
            return addCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newItemList[indexPath.row].0 == .add {
            if newItemList.count < 5 {
                newItemList.insert((.input, ""), at: indexPath.row)
            }
            if newItemList.count == 5 {
                newItemList[indexPath.row] = (CellType.input, "")
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
                let cell = self.todoListTableView.cellForRow(at: indexPath) as! ToDoItemCellForAdd
                // textFieldの初期化
                cell.resetTextField()
                newItemList.remove(at: indexPath.row)
                // 入力したテキストを保存
                // .addを含んでいない場合
                if !newItemList.contains(where: { $0 == (CellType.add, nil) }) {
                    newItemList.append((CellType.add, nil))
                }
                tableView.reloadData()
                return
            }
        }
    }

    @IBAction func addTodoItemButton(_ sender: UIBarButtonItem) {
        // newItemListからテキストを取り出す
        var textFieldValueArray: [String] = []
        let numberOfCell = todoListTableView.numberOfRows(inSection: 0)
        for row in 0..<numberOfCell {
            if let todoItemText = newItemList[row].1 {
                textFieldValueArray.append(todoItemText)
            }
        }
        // Realmへ保存する
        let realm = try! Realm()
        try! realm.write {
            let newTodoListForRealm: [String: Any] = ["toDoList": textFieldValueArray]
            let todoModel = ToDoModel(value: newTodoListForRealm)
            realm.add(todoModel)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
