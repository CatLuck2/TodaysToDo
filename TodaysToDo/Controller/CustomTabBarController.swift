//
//  CustomTabBarController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/11.
//

import UIKit

class CustomTabBarController: UITabBarController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let names = ["Main", "Analytics", "Settings"]

        var viewControllers = [UIViewController]()
        for name in names {
            let storyboard = UIStoryboard(name: name, bundle: nil)
            if let viewController = storyboard.instantiateInitialViewController() {
                switch name {
                case "Main":
                    viewController.tabBarItem = UITabBarItem(title: "メイン", image: UIImage(systemName: "checkmark"), tag: 0)
                case "Analytics":
                    viewController.tabBarItem = UITabBarItem(title: "統計", image: UIImage(systemName: "checkmark"), tag: 1)
                case "Settings":
                    viewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "checkmark"), tag: 2)
                default:
                    break
                }
                viewControllers.append(viewController)
            }
        }
        setViewControllers(viewControllers, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
