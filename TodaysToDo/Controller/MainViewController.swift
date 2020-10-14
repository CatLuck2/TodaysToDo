//
//  MainViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var todoListView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListView.layer.borderWidth = 0.5
        todoListView.layer.cornerRadius = 15
    }

    @IBAction func todoListViewTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            /// Realmに保存
        }
    }

}
