//
//  ToDoListEditViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoListEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.register(UINib(nibName: "ToDoItemCell", bundle: Bundle.main), forCellReuseIdentifier: "toDoItemCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell") as! ToDoItemCell
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    }

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
