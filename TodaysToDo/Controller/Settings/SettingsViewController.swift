//
//  SettingsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import Accounts
import SafariServices

// セクション用
private enum SectionType: Int {
    case task //タスク
    case other //その他
    case data //データ
}
// タスク用
private enum TaskType: Int {
    case endtimeOfTask //終了時刻
    case numberOfTask //設定数
    case priorityOfTask //優先順位
}
// その他メニュー用
private enum OtherType: Int {
    case help //ヘルプ
    case share //シェア
    case developerAccount //開発者Twitter
    case contact //お問い合わせ
}
// データ関連用
private enum DataType: Int {
    case delete //データ削除
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var settingsTableView: UITableView!

    // セクションタイトル
    // [[一般],[アラート],[そのほか]]
    private let settingsSectionTitle = ["タスク", "その他", "データ"]
    // 各セクションのメニュー
    private let settingsMenuTitle = [["終了時刻", "設定数", "優先順位"], ["ヘルプ", "共有", "開発者のTwitter", "お問い合わせ"], ["データ削除"]]
    private(set) var endtimeValueOfTask: (Int, Int)!
    private(set) var numberValueOfTask: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView()
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
        case .data:
            return settingsMenuTitle[2].count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        settingsSectionTitle[section]
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
                cell.detailTextLabel?.text = "テスト"
            case .numberOfTask:
                cell.detailTextLabel?.text = "テスト"
            case .priorityOfTask:
                break
            }
        case .other:
            cell.textLabel?.text = settingsMenuTitle[1][indexPath.row]
        case .data:
            cell.textLabel?.text = settingsMenuTitle[2][indexPath.row]
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
            switch taskType {
            case .endtimeOfTask:
                let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
                let customAlertVC = storyboard.instantiateViewController(withIdentifier: "segueToCustomAlert") as! CustomAlertViewController
                customAlertVC.pickerMode = .endtimeOfTask
                UIApplication.topViewController()?.present(customAlertVC, animated: true, completion: nil)
            case .numberOfTask:
                let storyboard = UIStoryboard(name: "CustomAlert", bundle: nil)
                let customAlertVC = storyboard.instantiateViewController(withIdentifier: "segueToCustomAlert") as! CustomAlertViewController
                customAlertVC.pickerMode = .numberOfTask
                UIApplication.topViewController()?.present(customAlertVC, animated: true, completion: nil)
            case .priorityOfTask:
                break
            }
        case .other:
            guard let otherType = OtherType(rawValue: indexPath.row) else {
                return
            }
            switch otherType {
            case .help:
                performSegue(withIdentifier: IdentifierType.segueToHelp, sender: nil)
            case .share:
                let shareText = "今日のタスクに集中して取り組めるアプリ -¥ TodaysTodo"
                let shareURL = URL(string: "https://www.apple.com/jp/watch/")!
                let activityVc = UIActivityViewController(activityItems: [shareText, shareURL], applicationActivities: nil)
                present(activityVc, animated: true, completion: nil)
            case .developerAccount:
                let webPage = "https://mobile.twitter.com/nekokichi1_yos2"
                let safariVC = SFSafariViewController(url: (URL(string: webPage)!))
                present(safariVC, animated: true, completion: nil)
            case .contact:
                performSegue(withIdentifier: IdentifierType.segueToContact, sender: nil)
            }
        case .data:
            guard let dataType = DataType(rawValue: indexPath.row) else {
                return
            }
            switch dataType {
            case .delete:
                break
            }
        }
    }

    @IBAction private func unwindToSettingVC(_ unwindSegue: UIStoryboardSegue) {
        let customAlertVC = unwindSegue.source as! CustomAlertViewController
        switch customAlertVC.pickerMode! {
        case .endtimeOfTask:
            endtimeValueOfTask = customAlertVC.selectedEndtime!
        case .numberOfTask:
            numberValueOfTask = customAlertVC.selectedNumber!
        }
        settingsTableView.reloadData()
    }

}
