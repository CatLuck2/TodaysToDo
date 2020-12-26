//
//  PopupViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/26.
//

import UIKit
import RealmSwift

final class PopupViewController: UIViewController {

    @IBOutlet private weak var popupParentView: UIView!
    @IBOutlet private weak var popupStackView: UIStackView!
    @IBOutlet private weak var popupTopAnchor: NSLayoutConstraint!
    @IBOutlet private weak var popupBottomAnchor: NSLayoutConstraint!
    private var viewModel: PopupViewModel!
    private let realm = try! Realm()
    private var tableViewController = TableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = PopupViewModel(todoLogicModel: SharedModel.todoListLogicModel)

        // デバイスの高さに応じて、ポップアップの上端の制約を調整
        switch self.view.frame.height {
        case 400.0..<500.0:
            setAnchorConstraintDependOnDevaice(per: 100)
        case 500.0..<600.0:
            setAnchorConstraintDependOnDevaice(per: 120)
        case 600.0..<700.0:
            setAnchorConstraintDependOnDevaice(per: 140)
        case 700.0..<800.0:
            setAnchorConstraintDependOnDevaice(per: 160)
        case 800.0..<850.0:
            setAnchorConstraintDependOnDevaice(per: 180)
        case 850.0..<899.0:
            setAnchorConstraintDependOnDevaice(per: 200)
        default:
            break
        }

        // popupStackViewにtableViewを追加
        setAutoLayoutAndUIInStackView()
    }

    private func setAutoLayoutAndUIInStackView() {
        tableViewController = TableViewController()
        addChild(tableViewController)
        tableViewController.view.layer.borderWidth = 1
        tableViewController.view.layer.cornerRadius = 5
        popupStackView.addArrangedSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        // popupStackViewにbuttonを追加
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .link
        doneButton.layer.cornerRadius = 5
        doneButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        popupStackView.addArrangedSubview(doneButton)

        // popupStackViewにAutoLaytoutを施す
        popupStackView.translatesAutoresizingMaskIntoConstraints = false
        popupStackView.leadingAnchor.constraint(equalTo: popupParentView.leadingAnchor, constant: 20.0).isActive = true
        popupStackView.trailingAnchor.constraint(equalTo: popupParentView.trailingAnchor, constant: -20.0).isActive = true
        popupStackView.topAnchor.constraint(equalTo: popupParentView.topAnchor, constant: 20.0).isActive = true
        popupStackView.bottomAnchor.constraint(equalTo: popupParentView.bottomAnchor, constant: -20.0).isActive = true
    }

    private func setAnchorConstraintDependOnDevaice(per: CGFloat) {
        // 上端制約のデフォルト値：85
        popupTopAnchor.constant *= (per / 100)
        // 下端制約のデフォルト値：80
        popupBottomAnchor.constant *= (per / 100)
    }

    private func saveTaskListDataAndAverageToRealm() {
        // 初回
        // 次回以降
        // タスクデータを作成/保存
        let taskModel = TaskListData()
        taskModel.date = DateFormatter().getCurrentDate()
        taskModel.numberOfTask = tableViewController.getNumOfTask()
        taskModel.numberOfCompletedTask = tableViewController.getNumOfCheckedTask()
        try! realm.write {
            RealmResults.sharedInstance[0].taskListDatas.append(taskModel)
        }

        // 達成率を算出
        var totalOfTask: Int = 0
        var totalOfCompletedTask: Int = 0
        for task in RealmResults.sharedInstance[0].taskListDatas {
            totalOfTask += task.numberOfTask
            totalOfCompletedTask += task.numberOfCompletedTask
        }
        let avergePerOfCompletedTask = Int((Double(totalOfCompletedTask) / Double(totalOfTask)) * 100)
        try! realm.write {
            RealmResults.sharedInstance[0].percentOfComplete = avergePerOfCompletedTask
            // 達成率の算出にtodoListが必要なので、算出後にtodoListを初期化
            RealmResults.sharedInstance[0].todoList.removeAll()
        }
    }

    private func saveSortedTaskListDataByPeriodsToRealm() {
        // タイムゾーンを指定
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        // 初期化
        try! realm.write {
            RealmResults.sharedInstance[0].weekList.removeAll()
            RealmResults.sharedInstance[0].monthList.removeAll()
            RealmResults.sharedInstance[0].yearList.removeAll()
        }

        // 今週
        // 今週の各日付、タスクの日付を比較していく
        for day in calendar.getAllDaysOfWeek {
            for taskData in RealmResults.sharedInstance[0].taskListDatas {
                // 今週の中の日付が存在する？
                if !calendar.isDate(taskData.date!, inSameDayAs: day) {
                    continue
                }
                try! realm.write {
                    RealmResults.sharedInstance[0].weekList.append(taskData)
                }
            }
        }

        // 今月
        for day in calendar.getAllDaysOfMonth(date: Date()) {
            for taskData in RealmResults.sharedInstance[0].taskListDatas {
                // 今週の中の日付が存在する？
                if !calendar.isDate(taskData.date!, inSameDayAs: day) {
                    continue
                }
                try! realm.write {
                    RealmResults.sharedInstance[0].monthList.append(taskData)
                }
            }
        }

        // 今年
        for month in calendar.getAllMonthsOfYear(date: Date()) {
            var totalOfInMonth: Int! = 0
            for taskData in RealmResults.sharedInstance[0].taskListDatas {
                // 同じ月が存在する？
                if !calendar.isDate(month, equalTo: taskData.date!, toGranularity: .month) {
                    continue
                }
                // 合致する月のタスクデータのチェック数を足していく
                totalOfInMonth += taskData.numberOfCompletedTask
            }
            let yearModel = TotalOfCompletedTaskInYear()
            yearModel.monthOfYear = month
            yearModel.total = totalOfInMonth
            try! realm.write {
                RealmResults.sharedInstance[0].yearList.append(yearModel)
            }
        }
    }

    @objc
    private func closePopup() {
        // UserDefault（キー：dateWhenDidEndTask）を現在時刻に更新
        UserDefaults.standard.set(Date(), forKey: IdentifierType.dateWhenDidEndTask)

        // Realmとのやり取り
        viewModel.saveTaskListData(date: DateFormatter().getCurrentDate(), numOfTask: tableViewController.getNumOfTask(), numOfCompletedTask: tableViewController.getNumOfCheckedTask())

        performSegue(withIdentifier: R.segue.popupViewController.unwindSegueFromPopupToMain, sender: nil)
    }

}
