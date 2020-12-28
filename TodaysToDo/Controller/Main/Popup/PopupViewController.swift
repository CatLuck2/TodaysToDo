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
        // 上端制約のデフォルト値：85
        popupTopAnchor.constant *= viewModel.getPerByDevice(viewHeight: self.view.frame.height)
        // 下端制約のデフォルト値：80
        popupBottomAnchor.constant *= viewModel.getPerByDevice(viewHeight: self.view.frame.height)

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
        viewModel.setConstraintForStackView(stackView: popupStackView, parentView: popupParentView)
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
