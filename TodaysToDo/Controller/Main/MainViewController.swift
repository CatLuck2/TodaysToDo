//
//  MainViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet private weak var todoListStackView: UIStackView!
    private var request: UNNotificationRequest!
    private let center = UNUserNotificationCenter.current()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realmにデータが保存されてるかを確認
        let realm = try! Realm()
        if RealmResults.sharedInstance[0].todoList.isEmpty == false {
            RealmResults.sharedInstance = realm.objects(ToDoModel.self)
            setTodoListForEdit(numberOfItems: RealmResults.sharedInstance[0].todoList.count)
        } else {
            setTodoListForAdd()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
    }

    // タスクリストのレイアウトを調整
    private func setTodoListForAdd() {
        todoListStackView.layer.borderWidth = 0
        todoListStackView.layer.cornerRadius = 5
        // todoListStackViewの子要素を全て削除
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 59).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "タスクを追加"
        label.textAlignment = .center
        view.addSubview(label)

        // AutoLayout
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true

        todoListStackView.addArrangedSubview(view)
    }

    private func setTodoListForEdit(numberOfItems: Int) {
        todoListStackView.layer.borderWidth = 1
        // todoListStackViewの子要素を全て削除
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        // 子要素View(>Label)を生成し、AutoLayoutを設定し、todoListViewに組み込む
        for n in 0..<numberOfItems {
            let view = UIView()
            view.heightAnchor.constraint(equalToConstant: 59).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = RealmResults.sharedInstance[0].todoList[n]
            label.textAlignment = .center
            view.addSubview(label)

            // AutoLayout
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
            view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true

            todoListStackView.addArrangedSubview(view)
        }
    }

    @objc
    private func displayPopup(_ notification: Notification) {
        //ポップアップを表示
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "segueToPopup") as! PopupViewController
        UIApplication.topViewController()?.present(popupVC, animated: true, completion: nil)
        // Notificationを削除
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        // タスクリストがあれば追加画面へ、無ければ編集画面へ
        if RealmResults.sharedInstance[0].todoList.isEmpty == false {
            /// テスト用のNotification
            let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            content.title = "アラート"
            content.body = "タスク完了日時になりました"
            request = UNNotificationRequest(identifier: "CalendarNotification", content: content, trigger: testTrigger)
            center.add(request) { (error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            // Notificationを登録
            NotificationCenter.default.addObserver(self, selector: #selector(displayPopup), name: Notification.Name(rawValue: "notification"), object: nil)
            performSegue(withIdentifier: IdentifierType.segueToEditFromMain, sender: RealmResults.sharedInstance)
        } else {
            performSegue(withIdentifier: IdentifierType.segueToAddFromMain, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierType.segueToEditFromMain {
            // 安全にアンラップするためにguard-let文を使用
            // クラッシュを避けるため、returnを使用
            guard let nvc = segue.destination as? UINavigationController else {
                return
            }
            guard let todoListEditVC = nvc.viewControllers[0] as? ToDoListEditViewController else {
                return
            }
            guard let results = sender as? Results<ToDoModel> else {
                return
            }
            todoListEditVC.results = results
        }
    }

    @IBAction private func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        /// 本番用のNotification
        // UNUserNotificationを登録
        //        let triggerDate = DateComponents(hour: 13, minute: 29)
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        //        let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        //        let content = UNMutableNotificationContent()
        //        content.sound = UNNotificationSound.default
        //        content.title = "アラート"
        //        content.body = "タスク完了日時になりました"
        //        request = UNNotificationRequest(identifier: "CalendarNotification", content: content, trigger: testTrigger)
        //        center.add(request) { (error: Error?) in
        //            if let error = error {
        //                print(error.localizedDescription)
        //            }
        //        }
        //        // Notificationを登録
        //        NotificationCenter.default.addObserver(self, selector: #selector(displayPopup), name: Notification.Name(rawValue: "notification"), object: nil)
    }
}

extension UIApplication {
    // RootViewController -> CustomTabBarController
    // -> tab.selectedViewController -> MainViewController
    // -> base?.presentedViewController -> UINavigationController
    // -> UINavigationController.visibleViewController -> ToDoListEditViewController
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
