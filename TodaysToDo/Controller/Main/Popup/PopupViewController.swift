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
        // タスクリストを削除
        let realm = try! Realm()
        try! realm.write {
            // タスクリストを削除
            realm.delete(realm.objects(ToDoModel.self))
            // タスクリストに関するデータを保存
            let datas: [String: Any] = [
                "taskListDatas": [["date": Date(), "numberOfCompletedTask": 1]],
                "weekList": [["dayOfWeek": Date(), "total": 2]],
                "monthList": [["dayOfMonth": Date(), "total": 3]],
                "yearList": [["monthOfYear": Date(), "total": 4]],
                "percentOfComplete": 1
            ]
            let model = ToDoModel(value: datas)
            realm.add(model, update: .all)
            print(datas)
        }
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
