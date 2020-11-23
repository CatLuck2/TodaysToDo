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
            // 各データを初期化
            RealmResults.sharedInstance[0].todoList.removeAll()
            RealmResults.sharedInstance[0].weekList.removeAll()
            RealmResults.sharedInstance[0].monthList.removeAll()
            RealmResults.sharedInstance[0].yearList.removeAll()

            if RealmResults.sharedInstance[0].taskListDatas.indices.contains(0) == true {
                // 次回以降
                // 今週のデータを追加
                // タイムゾーンを指定
                var calender = Calendar.current
                calender.timeZone = TimeZone(identifier: "UTC")!
                // 今週の各日付、タスクの日付を比較していく
                for i in 0...6 {
                    let date = Calendar.current.date(byAdding: .day, value: i, to: Date().startOfWeek!)
                    for taskData in RealmResults.sharedInstance[0].taskListDatas {
                        // 今週の中の日付が存在する？
                        if calender.isDate(taskData.date!, inSameDayAs: date!) {
                            RealmResults.sharedInstance[0].weekList.append(taskData)
                        }
                    }
                }
            } else {
                // 初回
                let datas: [String: Any] = ["taskListDatas": [["date": Date().getCurrentDate(), "numberOfCompletedTask": 1]]
                ]
                let model = ToDoModel(value: datas)
                realm.add(model, update: .all)
            }
        }
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
