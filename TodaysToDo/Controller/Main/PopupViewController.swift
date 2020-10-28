//
//  PopupViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/26.
//

import UIKit
import RealmSwift

class PopupViewController: UIViewController {

    private let realm = try! Realm()

    @IBAction func closeButton(_ sender: UIButton) {
        try! realm.write {
            RealmResults.sharedInstance[0].todoList.removeAll()
        }
        performSegue(withIdentifier: IdentifierType.unwindSegueFromPopupToMain, sender: nil)
    }

}
