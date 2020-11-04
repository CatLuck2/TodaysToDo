//
//  PopupViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/26.
//

import UIKit
import RealmSwift

class PopupViewController: UIViewController {

    @IBOutlet private weak var popupStackView: UIStackView!
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        // popupStackViewにtableViewを追加
        let tableViewController = TableViewController()
        addChild(tableViewController)
        popupStackView.addArrangedSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        // popupStackViewにbuttonを追加
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .link
        doneButton.layer.cornerRadius = 5
        doneButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        popupStackView.addArrangedSubview(doneButton)
    }

    @objc
    private func closePopup() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(ToDoModel.self))
        }
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
