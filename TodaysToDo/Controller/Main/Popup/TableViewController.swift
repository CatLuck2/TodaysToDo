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
    private var isChecked: [Bool] = []
    // チェック機能がONかどうか
    private var isExecutedPriorityOfTask: Bool!
    // チェック可能かを示す値の配列
    private var statesOfTasks: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: IdentifierType.celllForPopup)
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        todoListTableView.allowsMultipleSelection = true
        todoListTableView.tableFooterView = UIView()

        // UserDefaultからデータを取得
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        // チェック機能がONならtrue, OFFならfalse、を代入
        isExecutedPriorityOfTask = settingsValueOfTask.priorityOfTask

        // isCheckedにタスクの数だけfalseを追加
        for _ in 0..<RealmResults.sharedInstance[0].todoList.count {
            isChecked.append(false)
            statesOfTasks.append(false)
        }
        // 0番目のセルはタップ可能に初期化
        statesOfTasks[0] = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        todoListTableView.layoutIfNeeded()
        todoListTableViewHeightConstraint.constant = todoListTableView.contentSize.height
        view.layoutIfNeeded()
        view.frame.size.height = todoListTableView.contentSize.height
    }

    func getNumOfTask() -> Int {
        RealmResults.sharedInstance[0].todoList.count
    }

    // チェックされたセルの数を返す
    func getNumOfCheckedTask() -> Int {
        var totalOfTrue = 0
        for value in isChecked where value == true {
            totalOfTrue += 1
        }
        return totalOfTrue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RealmResults.sharedInstance[0].todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.celllForPopup, for: indexPath)
        cell.textLabel?.text = RealmResults.sharedInstance[0].todoList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)

        // チェック可能状態を読み込む
        if isExecutedPriorityOfTask {
            if statesOfTasks[indexPath.row] {
                cell.selectionStyle = .default
                cell.textLabel?.alpha = 1.0
            } else {
                cell.selectionStyle = .none
                cell.textLabel?.alpha = 0.5
            }
        }

        // チェックマーク状態を読み込む
        if !isChecked[indexPath.row] {
            cell.accessoryType = .none
        } else if isChecked[indexPath.row] {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // チェック可能状態を読み込む
        if isExecutedPriorityOfTask {
            if statesOfTasks[indexPath.row] {
                return indexPath
            } else {
                return nil
            }
        }

        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        // チェックマークを付ける/外す
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                // 外す
                cell.accessoryType = .none
                isChecked[indexPath.row] = false
                // タップしたセル以降のセルの各状態をfalseに変更
                if isExecutedPriorityOfTask {
                    if statesOfTasks.count - 1 >= indexPath.row + 1 {
                        for row in indexPath.row + 1...statesOfTasks.count - 1 {
                            isChecked[row] = false
                            statesOfTasks[row] = false
                        }
                        tableView.reloadData()
                    }
                }
            } else {
                // つける
                cell.accessoryType = .checkmark
                isChecked[indexPath.row] = true
                // (indexPath.row + 1)番目のセルをチェック可能にする
                if isExecutedPriorityOfTask {
                    if statesOfTasks.count - 1 >= indexPath.row + 1 {
                        statesOfTasks[indexPath.row + 1] = true
                        tableView.reloadData()
                    }
                }
            }
        }
    }

}
