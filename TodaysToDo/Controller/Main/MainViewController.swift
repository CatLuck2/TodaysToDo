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
        RealmResults.sharedInstance = realm.objects(ToDoModel.self)
        // UserDefaultから前回のタスク終了日時を取得
        guard let beforeDate = UserDefaults.standard.object(forKey: IdentifierType.dateWhenDidEndTask) as? Date else {
            return
        }
        // 今日のタスクが終了したかの確認
        if Calendar.current.isDate(Date(), inSameDayAs: beforeDate) {
            // 今日は既にタスクが終了している
            setEndTaskOfTodayLayout()
            // StackViewのタップジェスチャーを削除
            guard let gesutres = todoListStackView.gestureRecognizers else {
                return
            }
            for gesture in gesutres {
                if let recognizer = gesture as? UITapGestureRecognizer {
                    todoListStackView.removeGestureRecognizer(recognizer)
                }
            }
            return
        }

        // StackViewにタップジェスチャーを追加
        todoListStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
        if RealmResults.isEmptyOfDataInRealm {
            // Realmに1度も保存してない
            setTodoListForAdd()
            return
        }
        if RealmResults.isEmptyOfTodoList {
            // タスクリストがない
            setTodoListForAdd()
        } else {
            // 既にデータがある
            setTodoListForEdit(numberOfItems: RealmResults.sharedInstance[0].todoList.count)
        }

//        if RealmResults.sharedInstance.isEmpty == true {
//
//        } else {
//            // Realmに最低1回は保存したことがある
//            if RealmResults.sharedInstance[0].todoList.isEmpty == true {
//
//            } else {
//                // 既にデータがある
//                setTodoListForEdit(numberOfItems: RealmResults.sharedInstance[0].todoList.count)
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
    }

    // タスク終了後のレイアウトを構築
    private func setEndTaskOfTodayLayout() {
        if #available(iOS 14, *) {
            todoListStackView.backgroundColor = .white
            todoListStackView.layer.borderWidth = 0
            todoListStackView.layer.cornerRadius = 0
        }
        todoListStackView.spacing = 30.0
        // todoListStackViewの子要素を全て削除
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }

        let imageView = UIImageView()
        imageView.image = UIImage(named: "タスク終了画像")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0 / 1.2).isActive = true

        let textView = UITextView()
        textView.textAlignment = .center
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.text = "本日のタスクは終了しました。"
        textView.isScrollEnabled = false

        todoListStackView.addArrangedSubview(imageView)
        todoListStackView.addArrangedSubview(textView)
    }

    // タスクリストのレイアウトを調整
    private func setTodoListForAdd() {
        // todoListStackViewの子要素を全て削除l
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        let view = UIView()
        if #available(iOS 14, *) {
            todoListStackView.backgroundColor = .lightGray
            todoListStackView.layer.borderWidth = 1
            todoListStackView.layer.cornerRadius = 5
        } else {
            view.backgroundColor = .lightGray
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 5
        }
        todoListStackView.spacing = 0
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
        // UserDefaultから設定項目のデータを取得
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        // todoListStackViewの子要素を全て削除
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        // 子要素View(>Label)を生成し、AutoLayoutを設定し、todoListViewに組み込む
        for n in 0..<numberOfItems {
            let view = UIView()
            // 優先機能はON?
            if settingsValueOfTask.priorityOfTask {
                // viewの背景色にヒートマップ的な色を指定
                let rgbPercentage: CGFloat = ((CGFloat(n) / CGFloat(numberOfItems)))
                view.backgroundColor = UIColor(red: 1.0, green: rgbPercentage, blue: 0.0, alpha: 1)
                view.layer.cornerRadius = 5
            } else {
                if #available(iOS 14, *) {
                    todoListStackView.backgroundColor = .lightGray
                } else {
                    view.backgroundColor = .lightGray
                }
            }
            if #available(iOS 14, *) {
                todoListStackView.layer.borderWidth = 1
                todoListStackView.layer.cornerRadius = 5
            } else {
                view.layer.borderWidth = 1
                view.layer.cornerRadius = 5
            }
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
    private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: R.segue.mainViewController.toToDoList, sender: nil)
    }

    @objc
    private func displayPopup(_ notification: Notification) {
        //ポップアップを表示
        guard let popupVC = R.storyboard.popup.instantiateInitialViewController() else {
            return
        }
        UIApplication.topViewController()?.present(popupVC, animated: true, completion: nil)
    }

    @IBAction private func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        guard let destinationVC = R.segue.toDoListViewController.unwindToMainVCFromToDoListVC(segue: unwindSegue)?.source else {
            return
        }

        if destinationVC is ToDoListViewController {
            completeTaskNotification()
            self.setTodoListForAdd()
        }

        if destinationVC is PopupViewController {
            // 今日は既にタスクが終了している
            setEndTaskOfTodayLayout()
            // StackViewのタップジェスチャーを削除
            guard let gesutres = todoListStackView.gestureRecognizers else {
                return
            }
            for gesture in gesutres {
                if let recognizer = gesture as? UITapGestureRecognizer {
                    todoListStackView.removeGestureRecognizer(recognizer)
                }
            }
        }
    }

    func completeTaskNotification() {
        // UNUserNotificationを登録
        // UserDefaultから設定項目の値を取得
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        guard let endTimeOfTaskHour = settingsValueOfTask.endTimeOfTask.x, let endTimeOfTaskMinute = settingsValueOfTask.endTimeOfTask.y else {
            return
        }
        let triggerDate = DateComponents(hour: endTimeOfTaskHour, minute: endTimeOfTaskMinute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "タスク完了日時になりました"
        content.body = "達成できたタスクをチェックしましょう"
        request = UNNotificationRequest(identifier: "CalendarNotification", content: content, trigger: trigger)
        center.add(request) { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        // Notificationを登録
        NotificationCenter.default.addObserver(self, selector: #selector(displayPopup), name: Notification.Name(rawValue: "notification"), object: nil)
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
