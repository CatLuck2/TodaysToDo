//
//  MainViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {

    @IBOutlet private weak var todoListStackView: UIStackView!
    // 検証用モデルの取得
    private var viewModel: MainViewModel!
    private let dispose = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realmにデータが保存されてるかを確認
        viewModel = MainViewModel(todoLogicModel: SharedModel.todoListLogicModel)
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

        if viewModel.getIsEmptyOfDataInRealm() {
            // Realmに1度も保存してない
            setTodoListForAdd()
            return
        }
        if viewModel.getIsEmptyOfTodoList() {
            // タスクリストがない
            setTodoListForAdd()
        } else {
            // 既にデータがある
            setTodoListForEdit(numberOfItems: viewModel.getCountOfTodoList())
        }
    }

    private func settingStackView(backgounrdColor: UIColor?, boarderWidth: CGFloat, cornerRadius: CGFloat) {
        if let color = backgounrdColor {
            todoListStackView.backgroundColor = color
        }
        todoListStackView.layer.borderWidth = boarderWidth
        todoListStackView.layer.cornerRadius = cornerRadius
    }

    private func deleteAllSubViewInStackView() {
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    // タスク終了後のレイアウトを構築
    private func setEndTaskOfTodayLayout() {
        deleteAllSubViewInStackView()
        if #available(iOS 14, *) {
            settingStackView(backgounrdColor: .white, boarderWidth: 0, cornerRadius: 0)
        }
        todoListStackView.spacing = 30.0
        // todoListStackViewの子要素を全て削除
        todoListStackView.addArrangedSubview(viewModel.getUIsForEndTask().0)
        todoListStackView.addArrangedSubview(viewModel.getUIsForEndTask().1)
    }

    // タスクリストのレイアウトを調整
    private func setTodoListForAdd() {
        // todoListStackViewの子要素を全て削除
        deleteAllSubViewInStackView()
        if #available(iOS 14, *) {
            settingStackView(backgounrdColor: .lightGray, boarderWidth: 1, cornerRadius: 5)
        }
        todoListStackView.spacing = 0
        todoListStackView.addArrangedSubview(viewModel.getUIsForAdd())
    }

    private func setTodoListForEdit(numberOfItems: Int) {
        // UserDefaultから設定項目のデータを取得
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        // todoListStackViewの子要素を全て削除
        deleteAllSubViewInStackView()
        if settingsValueOfTask.priorityOfTask {} else {
            if #available(iOS 14, *) {
                todoListStackView.backgroundColor = .lightGray
            }
        }
        if #available(iOS 14, *) {
            settingStackView(backgounrdColor: nil, boarderWidth: 1, cornerRadius: 5)
        }
        for n in 0..<numberOfItems {
            todoListStackView.addArrangedSubview(viewModel.getUIsForEditTask(numberOfItems: numberOfItems, numberOfItem: n))
        }
    }

    @objc
    private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: R.segue.mainViewController.toToDoList, sender: nil)
    }

    private func completeTaskNotification() {
        var request: UNNotificationRequest!
        let center = UNUserNotificationCenter.current()
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
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "notification"))
            .subscribe { _ in
                //ポップアップを表示
                guard let popupVC = R.storyboard.popup.instantiateInitialViewController() else {
                    return
                }
                UIApplication.topViewController()?.present(popupVC, animated: true, completion: nil)
            }.disposed(by: dispose)
    }

    @IBAction private func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        if R.segue.toDoListViewController.unwindToMainVCFromToDoListVC(segue: unwindSegue) != nil {
            completeTaskNotification()
            viewModel.read()
            if viewModel.getIsEmptyOfDataInRealm() {
                self.setTodoListForAdd()
            } else {
                self.setTodoListForEdit(numberOfItems: viewModel.getCountOfTodoList())
            }
        }

        if R.segue.popupViewController.unwindSegueFromPopupToMain(segue: unwindSegue) != nil {
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

}
