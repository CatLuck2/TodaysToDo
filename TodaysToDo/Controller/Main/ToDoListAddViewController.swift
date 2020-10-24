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
        case input // タスク名を入力するセル
        case add   // inputのセルを追加するセル
    }

    @IBOutlet private weak var todoListTableView: UITableView!
    // .addの要素でテキストがないことを示すためにnilを設置したく、String?、にした
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
            // textFieldの値が変更されるたびに呼ばれる
            inputCell.textFieldValueSender = { sender in
                // as! String以外でWarningを消す方法がわからなかった
                self.newItemList[indexPath.row].1 = sender as! String
            }
            guard let itemName = newItemList[indexPath.row].1 else {
                return inputCell
            }
            inputCell.todoItemTextField.text = itemName
            return inputCell
        case .add:
            let addCell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.newItemcCellID) as! NewToDoItemCell
            return addCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newItemList[indexPath.row].0 == .add {
            // 最大要素数は5つ
            // inputが3つ以下でinputセルを追加
            // inputが4つなら、最後尾のinputをaddへ変更
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
    }

    @IBAction private func addTodoItemButton(_ sender: UIBarButtonItem) {
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
            let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: textFieldValueArray]
            let model = ToDoModel(value: newTodoListForRealm)
            realm.add(model)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
