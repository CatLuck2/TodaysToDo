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
        "タスク編集と削除の操作方法",
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cellForHelp, for: indexPath) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = helpTitles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.helpViewController.segueToHelpDetail, sender: ["naigationTitle": helpTitles[indexPath.row], "indexPathRow": indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueInfo = R.segue.helpViewController.segueToHelpDetail(segue: segue) {

            guard let dataForHelpDetail = sender as? [String: Any] else {
                return
            }
            segueInfo.destination.navigationTitle = dataForHelpDetail["naigationTitle"] as! String

            switch dataForHelpDetail["indexPathRow"] as! Int {
            case 0:
                segueInfo.destination.helpTypeValue = .whatIsTodaysTodo
            case 1:
                segueInfo.destination.helpTypeValue = .tutorialCreateTask
            case 2:
                segueInfo.destination.helpTypeValue = .tutorialEditAndDeleteTask
            case 3:
                segueInfo.destination.helpTypeValue = .whatIsEndTime
            case 4:
                segueInfo.destination.helpTypeValue = .tutorialEndTime
            case 5:
                segueInfo.destination.helpTypeValue = .whatIsPriority
            default:
                break
            }
        }
    }
}
