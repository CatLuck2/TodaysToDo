//
//  SettingsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RealmSwift
import Accounts
import SafariServices

// セクション用
private enum SectionType: Int {
    case task, other, deleteTask, deleteAll //タスク,その他、データ削除、全データ削除
}
// タスク用
private enum TaskType: Int {
    case endtimeOfTask, numberOfTask, priorityOfTask //終了時刻、設定数、優先順位
}
// その他メニュー用
private enum OtherType: Int {
    case help, share, developerAccount, contact //ヘルプ、シェア、開発者Twitter、お問い合わせ
}
// タスクリスト削除
private enum DeleteTaskType: Int {
    case deleteTask //タスクリストを削除
}

// 全データ削除
private enum DeleteAllType: Int {
    case deleteAll //全データ削除
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var settingsTableView: UITableView!

    // セクションタイトル
    // [[一般],[アラート],[そのほか]]
    private let settingsSectionTitle = ["タスク", "その他", "タスクデータ削除", "全データ削除"]
    // 各セクションのメニュー
    private let settingsMenuTitle = [["終了時刻", "設定数", "優先順位"], ["ヘルプ", "共有", "開発者のTwitter", "お問い合わせ"], ["タスクデータを削除"], ["全データを削除"]]
    private(set) var endtimeValueOfTask: (Int, Int)!
    private(set) var numberValueOfTask: Int!
    private(set) var isExecutedPriorityOfTask: Bool!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // UserDefaultからタスク項目の値を取得
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        guard let endTimeOfTaskHour = settingsValueOfTask.endTimeOfTask.x, let endtimeOfTaskMinute = settingsValueOfTask.endTimeOfTask.y else {
            return
        }
        self.endtimeValueOfTask = (endTimeOfTaskHour, endtimeOfTaskMinute)
        numberValueOfTask = settingsValueOfTask.numberOfTask
        isExecutedPriorityOfTask = settingsValueOfTask.priorityOfTask
        settingsTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView()
    }

    private func getStringOfMinutes(number: Int) -> String {
        var i = 0
        var num = number
        // num == 0
        if num == 0 {
            return "00"
        }
        // num > =
        while num > 0 {
            num /= 10
            i += 1
        }

        switch i {
        case 1:
            return "0\(number)"
        case 2:
            return "\(number)"
        default:
            return ""
        }
    }

    @objc
    private func toggleSwitchInCell(_ sender: UISwitch) {
        isExecutedPriorityOfTask = sender.isOn
        // UserDefaultに保存
        let sv = SettingsValue()
        sv.saveSettingsValue(endTime: self.endtimeValueOfTask, number: self.numberValueOfTask, priority: self.isExecutedPriorityOfTask)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        settingsSectionTitle.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else {
            return 0
        }
        switch sectionType {
        case .task:
            return settingsMenuTitle[0].count
        case .other:
            return settingsMenuTitle[1].count
        case .deleteTask:
            // Realmに何のデータも無ければ、データ削除のセクションは非表示
            if RealmResults.sharedInstance.indices.contains(0) == false {
                return 0
            }
            if RealmResults.sharedInstance[0].todoList.isEmpty == true {
                return 0
            }
            return settingsMenuTitle[2].count
        case .deleteAll:
            // Realmに何のデータも無ければ、データ削除のセクションは非表示
            if RealmResults.sharedInstance.indices.contains(0) == false {
                return 0
            }
            if RealmResults.sharedInstance[0].taskListDatas.isEmpty == true {
                return 0
            }
            return settingsMenuTitle[3].count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2: //タスクデータ削除
            // Realmに何のデータも無ければ、データ削除のセクションは非表示
            if RealmResults.sharedInstance.indices.contains(0) == false {
                return nil
            }
            if RealmResults.sharedInstance[0].todoList.isEmpty == true {
                return nil
            }
        case 3: //全データ削除
            // Realmに何のデータも無ければ、データ削除のセクションは非表示
            if RealmResults.sharedInstance.indices.contains(0) == false {
                return nil
            }
            if RealmResults.sharedInstance[0].taskListDatas.isEmpty == true {
                return nil
            }
        default:
            break
        }
        return settingsSectionTitle[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellForSettingsID")
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return cell
        }
        switch sectionType {
        case .task:
            cell.textLabel?.text = settingsMenuTitle[0][indexPath.row]
            guard let taskType = TaskType(rawValue: indexPath.row) else {
                return cell
            }
            switch taskType {
            case .endtimeOfTask:
                cell.detailTextLabel?.text = "\(endtimeValueOfTask.0):" + getStringOfMinutes(number: endtimeValueOfTask.1)
            case .numberOfTask:
                if let num = numberValueOfTask {
                    cell.detailTextLabel?.text = "\(num)"
                }
            case .priorityOfTask:
                let switchView = UISwitch()
                switchView.addTarget(self, action: #selector(toggleSwitchInCell(_:)), for: .valueChanged)
                // switchViewの初期値
                switchView.isOn = self.isExecutedPriorityOfTask
                cell.accessoryView = switchView
            }
        case .other:
            cell.textLabel?.text = settingsMenuTitle[1][indexPath.row]
        case .deleteTask:
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = settingsMenuTitle[2][indexPath.row]
        case .deleteAll:
            cell.textLabel?.textColor = .red
            cell.textLabel?.text = settingsMenuTitle[3][indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return
        }
        switch sectionType {
        case .task:
            guard let taskType = TaskType(rawValue: indexPath.row) else {
                return
            }
            processOfTaskTypeInDidSelectRowAt(taskType: taskType)
        case .other:
            guard let otherType = OtherType(rawValue: indexPath.row) else {
                return
            }
            processOfOtherTypeInDidSelectRowAt(otherType: otherType)
        case .deleteTask:
            presentAlertRelatedDeleteTypeInDidSelectRowAt(title: "警告", message: "作成済みのタスクリストを削除してもよろしいですか？") {
                // タスクリストを削除
                let realm = try! Realm()
                try! realm.write {
                    RealmResults.sharedInstance[0].todoList.removeAll()
                }
                // 通知類を削除
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "notification"), object: nil)
                // 削除したことをアラートで表示
                let resultAlert = UIAlertController(title: "削除", message: "タスクリストを削除しました", preferredStyle: .alert)
                resultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.settingsTableView.reloadData()
                }))
                self.present(resultAlert, animated: true, completion: nil)
            }
        case .deleteAll:
            presentAlertRelatedDeleteTypeInDidSelectRowAt(title: "警告", message: "本アプリの全データを削除しますが、よろしいですか？") {
                // Realmの全データを削除
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                // 通知類を削除
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "notification"), object: nil)
                // UserDefaultの日付をデフォルト値にリセット
                UserDefaults.standard.set(Date(timeIntervalSince1970: -1.0), forKey: IdentifierType.dateWhenDidEndTask)
                // 削除したことを通知
                let resultAlert = UIAlertController(title: "削除", message: "全データを削除しました", preferredStyle: .alert)
                resultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.settingsTableView.reloadData()
                }))
                self.present(resultAlert, animated: true, completion: nil)
            }
        }
    }

    func presentAlertRelatedDeleteTypeInDidSelectRowAt(title: String, message: String, completionOfOkAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
            completionOfOkAction()
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func processOfTaskTypeInDidSelectRowAt(taskType: TaskType) {
        switch taskType {
        case .endtimeOfTask:
            let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
            let customAlertVC = storyboard.instantiateViewController(withIdentifier: "segueToCustomAlert") as! CustomAlertViewController
            customAlertVC.setInitializeFromAnotherVC(pickerMode: .endtimeOfTask, selectedEndTime: (endtimeValueOfTask))
            UIApplication.topViewController()?.present(customAlertVC, animated: true, completion: nil)
        case .numberOfTask:
            let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
            let customAlertVC = storyboard.instantiateViewController(withIdentifier: "segueToCustomAlert") as! CustomAlertViewController
            customAlertVC.pickerMode = .numberOfTask
            customAlertVC.selectedNumber = numberValueOfTask
            UIApplication.topViewController()?.present(customAlertVC, animated: true, completion: nil)
        case .priorityOfTask:
            break
        }
    }

    private func processOfOtherTypeInDidSelectRowAt(otherType: OtherType) {
        switch otherType {
        case .help:
            performSegue(withIdentifier: IdentifierType.segueToHelp, sender: nil)
        case .share:
            let shareText = "今日のタスクに集中して取り組めるアプリ - TodaysTodo"
            guard let shareURL = URL(string: "https://www.apple.com/jp/watch/") else {
                return
            }
            let activityVc = UIActivityViewController(activityItems: [shareText, shareURL], applicationActivities: nil)
            present(activityVc, animated: true, completion: nil)
        case .developerAccount:
            guard let webPageURL = URL(string: IdentifierType.urlForDeveloperTwitter) else {
                return
            }
            let webPage = SFSafariViewController(url: webPageURL)
            present(webPage, animated: true, completion: nil)
        case .contact:
            guard let contactPageURL = URL(string: IdentifierType.urlForGoogleForm) else {
                return
            }
            let contactPage = SFSafariViewController(url: contactPageURL)
            present(contactPage, animated: true, completion: nil)
        }
    }

    @IBAction private func unwindToSettingVC(_ unwindSegue: UIStoryboardSegue) {
        if let customAlertVC = unwindSegue.source as? CustomAlertViewController,
           let pickerMode = customAlertVC.pickerMode,
           let selectedEndTime = customAlertVC.selectedEndTime,
           let selectedNumber = customAlertVC.selectedNumber {
            switch pickerMode {
            case .endtimeOfTask:
                self.endtimeValueOfTask = selectedEndTime
            case .numberOfTask:
                self.numberValueOfTask = selectedNumber
            }
            // UserDefaultに保存
            let sv = SettingsValue()
            sv.saveSettingsValue(endTime: self.endtimeValueOfTask, number: self.numberValueOfTask, priority: self.isExecutedPriorityOfTask)
            settingsTableView.reloadData()
        }
    }

}
