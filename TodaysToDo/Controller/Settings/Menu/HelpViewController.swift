//
//  HelpViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/05.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var helpTableView: UITableView!

    private let helpTitles = [
        "TodayTodoとは？",
        "タスク作成画面の操作方法",
        "タスク終了時刻とは？",
        "タスク終了時刻後の流れ",
        "タスク優先順位とは？"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        helpTableView.delegate = self
        helpTableView.dataSource = self
        helpTableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        helpTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IdentifierType.cellForHelp, for: indexPath)
        cell.textLabel?.text = helpTitles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: IdentifierType.segueToHelpDetail, sender: helpTitles[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierType.segueToHelpDetail {
            let helpDetailVC = segue.destination as! HelpDetailViewController
            guard let _ = sender as? String else { return }
            helpDetailVC.navigationTitle = sender as! String
        }
    }
}
