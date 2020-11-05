//
//  SettingsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var settingsTableView: UITableView!

    // 一般
    private var generalMenu = ["お知らせ","ダークモード"]
    // アラート
    private var alertMenu = ["サウンド","アイコンにバッジをつける"]
    // その他
    private var otherMenu = ["ヘルプ","共有","開発者のTwitter"]

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsMenu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForSettingsID", for: indexPath)
        cell.textLabel?.text = settingsMenu[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
