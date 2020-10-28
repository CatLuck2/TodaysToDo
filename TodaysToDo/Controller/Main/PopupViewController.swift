//
//  PopupViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/26.
//

import UIKit
import RealmSwift

class PopupViewController: UIViewController {

    @IBOutlet weak var popupStackView: UIStackView!
    @IBOutlet weak var popupTableView: UITableView!
    private let realm = try! Realm()

    @IBAction func closeButton(_ sender: UIButton) {
        try! realm.write {
            RealmResults.sharedInstance[0].todoList.removeAll()
        }
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
