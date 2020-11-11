//
//  HelpDetailViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/10.
//

enum HelpType {
    case whatIsTodaysTodo
    case tutorialCreateTask
    case whatIsEndTime
    case tutorialEndTime
    case whatIsPriority
}

import UIKit

class HelpDetailViewController: UIViewController {

    var navigationTitle: String!
    var helpTypeValue: HelpType!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard self.navigationController != nil else {
            return
        }
        self.navigationItem.title = navigationTitle

        switch helpTypeValue {
        case .whatIsTodaysTodo:
            break
        case .tutorialCreateTask:
            break
        case .whatIsEndTime:
            break
        case .tutorialEndTime:
            break
        case .whatIsPriority:
            break
        case .none:
            break
        }
    }

}
