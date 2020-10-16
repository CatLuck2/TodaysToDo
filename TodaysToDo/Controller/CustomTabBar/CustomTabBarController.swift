//
//  CustomTabBarController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/12.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 各StoryBoardの名前
        let names = ["Main", "Analytics", "Settings"]
        var viewControllers = [UIViewController]()
        // TabBarItemを設定したViewControllerをfor文で追加
        for name in names {
            let storyboard = UIStoryboard(name: name, bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            switch name {
            case "Main":
                viewController.tabBarItem = UITabBarItem(title: "メイン", image: UIImage(systemName: "note"), tag: 0)
            case "Analytics":
                viewController.tabBarItem = UITabBarItem(title: "統計", image: UIImage(systemName: "list.dash"), tag: 1)
            case "Settings":
                viewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gearshape"), tag: 2)
            default:
                break
            }
            viewControllers.append(viewController)
        }
        setViewControllers(viewControllers, animated: false)
    }

}
