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
        performSegue(withIdentifier: IdentifierType.segueToHelpDetail, sender: ["naigationTitle": helpTitles[indexPath.row], "indexPathRow": indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierType.segueToHelpDetail {
            let helpDetailVC = segue.destination as! HelpDetailViewController

            guard let dataForHelpDetail = sender as? [String: Any] else {
                return
            }
            helpDetailVC.navigationTitle = dataForHelpDetail["naigationTitle"] as! String

            switch dataForHelpDetail["indexPathRow"] as! Int {
            case 0:
                helpDetailVC.helpTypeValue = .whatIsTodaysTodo
            case 1:
                helpDetailVC.helpTypeValue = .tutorialCreateTask
            case 2:
                helpDetailVC.helpTypeValue = .whatIsEndTime
            case 3:
                helpDetailVC.helpTypeValue = .tutorialEndTime
            case 4:
                helpDetailVC.helpTypeValue = .whatIsPriority
            default:
                break
            }
        }
    }
}
