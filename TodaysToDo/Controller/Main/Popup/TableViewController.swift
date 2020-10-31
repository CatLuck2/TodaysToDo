//
//  TableViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/29.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var todoListTableView: UITableView!
    @IBOutlet private weak var todoListTableViewHeightConstraint: NSLayoutConstraint!
    // チェックマーク状態の配列
    private var isChecked = [false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: IdentifierType.celllForPopup)
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.allowsMultipleSelection = true
        todoListTableView.tableFooterView = UIView()
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
        cell.textLabel?.text = RealmResults.sharedInstance[0].todoList[indexPath.row]
        // チェックマーク状態を読み込む
        if !isChecked[indexPath.row] {
            cell.accessoryType = .none
        } else if isChecked[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        // チェックマークを付ける/外す
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                isChecked[indexPath.row] = false
            } else {
                cell.accessoryType = .checkmark
                isChecked[indexPath.row] = true
            }
        }
    }

}
