//
//  TableViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/29.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var todoListTableView: UITableView! {
        didSet {
            todoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: IdentifierType.celllForPopup)
            todoListTableView.delegate = self
            todoListTableView.dataSource = self
        }
    }

    @IBOutlet private weak var todoListTableViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        todoListTableView.delegate = self
        todoListTableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        todoListTableView.layoutIfNeeded()
        todoListTableViewHeightConstraint.constant = todoListTableView.contentSize.height
        view.layoutIfNeeded()
        view.frame.size.height = todoListTableView.contentSize.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RealmResults.sharedInstance[0].todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.celllForPopup, for: indexPath)
        cell.textLabel!.text = RealmResults.sharedInstance[0].todoList[indexPath.row]
        return cell
    }

}
