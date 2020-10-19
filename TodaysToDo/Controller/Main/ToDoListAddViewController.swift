//
//  ToDoListAddViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/18.
//

import UIKit
import RealmSwift

class ToDoListAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.tableFooterView = UIView()
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: IdentifierType.cellID)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellID) as! ToDoItemCell
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }

    @IBAction func addTodoItemButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
