//
//  HelpViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/05.
//

enum HelpType {
    case whatIsTodaysTodo
    case tutorialCreateTask
    case tutorialEditAndDeleteTask
    case whatIsEndTime
    case tutorialEndTime
    case whatIsPriority
}

import UIKit
import RxSwift
import RxCocoa

final class HelpViewController: UIViewController {

    @IBOutlet private weak var helpTableView: UITableView!

    private let dispose = DisposeBag()
    private let helpTitles = [
        "TodayTodoとは？",
        "タスク作成画面の操作方法",
        "タスク編集と削除の操作方法",
        "タスク終了時刻とは？",
        "タスク終了時刻後の流れ",
        "タスク優先順位とは？"
    ]
    private let helpTypes = BehaviorRelay<[HelpType]>(value: [
        .whatIsTodaysTodo,
        .tutorialCreateTask,
        .tutorialEditAndDeleteTask,
        .whatIsEndTime,
        .tutorialEndTime,
        .whatIsPriority
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        helpTableView.tableFooterView = UIView()

        helpTypes.asObservable()
            .bind(to: helpTableView.rx.items(cellIdentifier: R.reuseIdentifier.cellForHelp.identifier)) { [self] row, element, cell in
                cell.textLabel?.text = helpTitles[row]
            }.disposed(by: dispose)

        helpTableView.rx.itemSelected
            .subscribe { [self] indexPath in
                performSegue(withIdentifier: R.segue.helpViewController.segueToHelpDetail, sender: ["naigationTitle": helpTitles[indexPath.row], "indexPathRow": indexPath.row])
            }.disposed(by: dispose)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueInfo = R.segue.helpViewController.segueToHelpDetail(segue: segue) {

            guard let dataForHelpDetail = sender as? [String: Any],
                  let navigationTitle = dataForHelpDetail["naigationTitle"] as? String,
                  let row = dataForHelpDetail["indexPathRow"] as? Int
                  else {
                return
            }
            segueInfo.destination.navigationTitle = navigationTitle
            segueInfo.destination.setHelpTypeValue(helpType: helpTypes.value[row])
        }
    }
}
