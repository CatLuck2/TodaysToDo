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

    @IBOutlet private weak var helpDetailTextView: UITextView!
    @IBOutlet private weak var helpDetailImageView: UIImageView!

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
            setTextView(text: "これはTodaysTodoです")
        case .tutorialCreateTask:
            setImageView(image: UIImage(systemName: "pencil")!)
        case .whatIsEndTime:
            setTextView(text: "これはタスク終了を通知するアラートの表示時刻です")
        case .tutorialEndTime:
            setImageView(image: UIImage(systemName: "pencil")!)
        case .whatIsPriority:
            setTextView(text: "これは優先順位が高い順でないとタスクを完了できなくさせる機能です")
        case .none:
            break
        }
    }

    private func setTextView(text: String) {
        helpDetailTextView.text = text
        helpDetailTextView.isHidden = false
    }

    private func setImageView(image: UIImage) {
        helpDetailImageView.image = image
        helpDetailImageView.isHidden = false
    }

}
