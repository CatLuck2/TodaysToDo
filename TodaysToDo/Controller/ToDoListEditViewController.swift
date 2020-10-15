//
//  ToDoListEditViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit
import RealmSwift

class ToDoListEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoListTableView: UITableView!

    var todoList: Results<ToDoModel>!

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: "toDoItemCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList[0].toDoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell") as! ToDoItemCell
        cell.setTodoItemCell(name: todoList[0].toDoList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }

    @IBAction func updateTodoItemButton(_ sender: UIBarButtonItem) {

    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
