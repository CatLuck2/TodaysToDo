//
//  HelpDetailViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/10.
//

import UIKit

class HelpDetailViewController: UIViewController {

    var navigationTitle: String!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.navigationController != nil else {
            return
        }
        self.navigationItem.title = navigationTitle
    }

}
