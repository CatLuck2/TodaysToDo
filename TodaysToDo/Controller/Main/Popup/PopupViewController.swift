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

    @objc
    private func closePopup() {
        // UserDefault（キー：dateWhenDidEndTask）を現在時刻に更新
        UserDefaults.standard.set(Date(), forKey: IdentifierType.dateWhenDidEndTask)

        // Realmとのやり取り
        viewModel.saveTaskListData(date: DateFormatter().getCurrentDate(), numOfTask: tableViewController.getNumOfTask(), numOfCompletedTask: tableViewController.getNumOfCheckedTask())

        performSegue(withIdentifier: R.segue.popupViewController.unwindSegueFromPopupToMain, sender: nil)
    }

}
