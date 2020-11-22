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

    override func viewDidLoad() {
        super.viewDidLoad()
        // popupStackViewにtableViewを追加
        let tableViewController = TableViewController()
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
            // todoListを削除
            RealmResults.sharedInstance[0].todoList.removeAll()
            if RealmResults.sharedInstance[0].taskListDatas.indices.contains(0) == true {
                // 次回以降
                // タスクリストに関するデータを保存
                let taskListModel = TaskListData()
                taskListModel.date = Date()
                taskListModel.numberOfCompletedTask = 5
                // 今週
                let weekModel = TotalOfCompletedTaskInWeek()
                weekModel.dayOfWeek = Date()
                weekModel.total = 3
                // 今月
                let monthModel = TotalOfCompletedTaskInMonth()
                monthModel.dayOfMonth = Date()
                monthModel.total = 3
                // 今年
                let yearModel = TotalOfCompletedTaskInYear()
                yearModel.monthOfYear = Date()
                yearModel.total = 3
                // Realmの既存データに追加
                RealmResults.sharedInstance[0].taskListDatas.append(taskListModel)
                RealmResults.sharedInstance[0].weekList.append(weekModel)
                RealmResults.sharedInstance[0].monthList.append(monthModel)
                RealmResults.sharedInstance[0].yearList.append(yearModel)
            } else {
                // 初回
                // taskListDatas以外は仮のデータ
                let datas: [String: Any] = [
                    "taskListDatas": [["date": Date(), "numberOfCompletedTask": 1]],
                    "weekList": [["dayOfWeek": Date(), "total": 2]],
                    "monthList": [["dayOfMonth": Date(), "total": 3]],
                    "yearList": [["monthOfYear": Date(), "total": 4]],
                    "percentOfComplete": 1
                ]
                let model = ToDoModel(value: datas)
                realm.add(model, update: .all)
            }
        }
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
