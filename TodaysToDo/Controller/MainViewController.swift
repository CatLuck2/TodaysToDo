//
//  MainViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet private weak var todoListView: UIStackView!
    @IBOutlet private weak var parentViewOfStack: UIView!

    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        parentViewOfStack.layer.borderWidth = 0.5
        parentViewOfStack.layer.cornerRadius = 15
    }

    @IBAction private func todoListViewTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Realmに保存
        }
    }

}
