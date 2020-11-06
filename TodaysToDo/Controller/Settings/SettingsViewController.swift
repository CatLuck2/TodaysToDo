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
    case general //一般
    case other //その他
}
// 一般メニュ-用
private enum GeneralType: Int {
    case information //お知らせ
}
// その他メニュー用
private enum OtherType: Int {
    case help //ヘルプ
    case share //シェア
    case developerAccount //開発者Twitter
    case contact //お問い合わせ
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var settingsTableView: UITableView!

    // セクションタイトル
    // [[一般],[アラート],[そのほか]]
    private let settingsSectionTitle = ["一般", "その他"]
    // 各セクションのメニュー
    private let settingsMenuTitle = [["お知らせ"], ["ヘルプ", "共有", "開発者のTwitter", "お問い合わせ"]]

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
        case .general:
            return settingsMenuTitle[0].count
        case .other:
            return settingsMenuTitle[1].count
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        settingsSectionTitle[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSettingsID", for: indexPath)
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return cell
        }
        switch sectionType {
        case .general:
            cell.textLabel?.text = settingsMenuTitle[0][indexPath.row]
        case .other:
            cell.textLabel?.text = settingsMenuTitle[1][indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return
        }
        switch sectionType {
        case .general:
            guard let generalType = GeneralType(rawValue: indexPath.row) else {
                return
            }
            switch generalType {
            case .information:
                performSegue(withIdentifier: IdentifierType.segueToInformation, sender: nil)
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
        }
    }

}
