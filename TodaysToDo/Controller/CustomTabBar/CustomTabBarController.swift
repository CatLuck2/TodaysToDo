//
//  CustomTabBarController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/12.
//

import UIKit

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // 各StoryBoardの名前
        let storyboardNames = ["Main", "Analytics", "Settings"]
        var viewControllers = [UIViewController]()
        // StoryboardReference先のViewControllerにタブバーを設定するため
        // 指定先のViewControllerらをTabBarControllerへ追加
        for storyboardName in storyboardNames {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {
                return
            }
            switch storyboardName {
            case "Main":
                viewController.tabBarItem = UITabBarItem(title: "メイン", image: UIImage(systemName: "list.bullet"), tag: 0)
            case "Analytics":
                viewController.tabBarItem = UITabBarItem(title: "統計", image: UIImage(systemName: "chart.bar.fill"), tag: 1)
            case "Settings":
                viewController.tabBarItem = UITabBarItem(title: "設定", image: UIImage(systemName: "gear"), tag: 2)
            default:
                break
            }
            viewControllers.append(viewController)
        }
        setViewControllers(viewControllers, animated: false)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AnalyticsViewController {
            if RealmResults.isEmptyOfDataInRealm || RealmResults.isEmptyOfTaskListDatas {
                let alert = UIAlertController(title: "エラー", message: "統計に必要なデータがありません", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

}
