//
//  PopupViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/26.
//

import UIKit
import RealmSwift

class PopupViewController: UIViewController {

    @IBOutlet weak var popupParentView: UIView!
    @IBOutlet private weak var popupStackView: UIStackView!
    private let realm = try! Realm()
    private var tableViewController = TableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // popupStackViewにtableViewを追加
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

    @objc
    private func closePopup() {
        // UserDefault（キー：dateWhenDidEndTask）を現在時刻に更新
        UserDefaults.standard.set(Date(), forKey: IdentifierType.dateWhenDidEndTask)

        // Realmとのやり取り
        let realm = try! Realm()
        // 初回
        try! realm.write {
            // 次回以降
            // タスクデータを作成/保存
            let taskModel = TaskListData()
            taskModel.date = Date().getCurrentDate()
            taskModel.numberOfTask = tableViewController.getNumOfTask()
            taskModel.numberOfCompletedTask = tableViewController.getNumOfCheckedTask()
            RealmResults.sharedInstance[0].taskListDatas.append(taskModel)

            // 達成率を算出
            var totalOfTask: Int = 0
            var totalOfCompletedTask: Int = 0
            for task in RealmResults.sharedInstance[0].taskListDatas {
                totalOfTask += task.numberOfTask
                totalOfCompletedTask += task.numberOfCompletedTask
            }
            let avergePerOfCompletedTask = Int((Double(totalOfCompletedTask) / Double(totalOfTask)) * 100)
            RealmResults.sharedInstance[0].percentOfComplete = avergePerOfCompletedTask
            // 達成率の算出にtodoListが必要なので、算出後にtodoListを初期化
            RealmResults.sharedInstance[0].todoList.removeAll()

            // 各期間でデータをソート
            // タイムゾーンを指定
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "UTC")!

            // 今週
            // 今週の各日付、タスクの日付を比較していく]
            RealmResults.sharedInstance[0].weekList.removeAll()
            for day in Date().allDaysOfWeek {
                for taskData in RealmResults.sharedInstance[0].taskListDatas {
                    // 今週の中の日付が存在する？
                    if calendar.isDate(taskData.date!, inSameDayAs: day) {
                        RealmResults.sharedInstance[0].weekList.append(taskData)
                    }
                }
            }

            // 今月
            RealmResults.sharedInstance[0].monthList.removeAll()
            for day in Date().allDaysOfMonth {
                for taskData in RealmResults.sharedInstance[0].taskListDatas {
                    // 今週の中の日付が存在する？
                    if calendar.isDate(taskData.date!, inSameDayAs: day) {
                        RealmResults.sharedInstance[0].monthList.append(taskData)
                    }
                }
            }

            // 今年
            RealmResults.sharedInstance[0].yearList.removeAll()
            for month in Date().allMonthsOfYear {
                var totalOfInMonth: Int! = 0
                for taskData in RealmResults.sharedInstance[0].taskListDatas {
                    // 同じ月が存在する？
                    if calendar.isDate(month, equalTo: taskData.date!, toGranularity: .month) {
                        // 合致する月のタスクデータのチェック数を足していく
                        totalOfInMonth += taskData.numberOfCompletedTask
                    }
                }
                let yearModel = TotalOfCompletedTaskInYear()
                yearModel.monthOfYear = month
                yearModel.total = totalOfInMonth
                RealmResults.sharedInstance[0].yearList.append(yearModel)
            }
        }
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
