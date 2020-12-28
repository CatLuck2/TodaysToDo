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
import RxSwift
import RxCocoa
import RxDataSources

final class SettingsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet private weak var settingsTableView: UITableView!

    private let dispose = DisposeBag()
    private let realm = try! Realm()
    private var viewModel = SettingsViewModel(todoLogicModel: SharedModel.todoListLogicModel)
    private var viewModelForRealm = SettingsViewModelForRealmModel(todoLogicModel: SharedModel.todoListLogicModel)
    private(set) var endtimeValueOfTask: (Int, Int)!
    private(set) var numberValueOfTask: Int!
    private(set) var isExecutedPriorityOfTask: Bool!
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SettingsSectionModel>(configureCell: configureCell)
    private lazy var configureCell:RxTableViewSectionedReloadDataSource<SettingsSectionModel>.ConfigureCell = { [self] (dataSource, tableView, indexPath, _) in
        let item = dataSource[indexPath]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: R.reuseIdentifier.cellForSettings.identifier)
        cell.textLabel?.text = item.title
        switch item {
        case .endtimeOfTask:
            cell.detailTextLabel?.text = "\(self.endtimeValueOfTask.0):" + self.viewModelForRealm.getStringOfMinutes(number: self.endtimeValueOfTask.1)
            return cell
        case .numberOfTask:
            if let num = self.numberValueOfTask {
                cell.detailTextLabel?.text = "\(num)"
            }
            return cell
        case .priorityOfTask:
            let switchView = UISwitch()
            switchView.addTarget(self, action: #selector(self.toggleSwitchInCell(_:)), for: .valueChanged)
            // switchViewの初期値
            switchView.isOn = self.isExecutedPriorityOfTask
            cell.accessoryView = switchView
            return cell
        case .help, .share, .developerAccount, .contact:
            return cell
        case .deleteTask:
            cell.textLabel?.textColor = .red
            return cell
        case .deleteAll:
            cell.textLabel?.textColor = .red
            return cell
        }
    }

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
        viewModel.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModel()
        settingsTableView.tableFooterView = UIView()
    }

    @objc
    private func toggleSwitchInCell(_ sender: UISwitch) {
        isExecutedPriorityOfTask = sender.isOn
        // UserDefaultに保存
        let sv = SettingsValue()
        sv.saveSettingsValue(endTime: self.endtimeValueOfTask, number: self.numberValueOfTask, priority: self.isExecutedPriorityOfTask)
    }

    private func setupViewModel() {
        viewModel = SettingsViewModel(todoLogicModel: SharedModel.todoListLogicModel)
        viewModel.items
            .bind(to: settingsTableView.rx.items(dataSource: dataSource))
            .disposed(by: dispose)
        viewModel.setup()
    }

    private func setupTableView() {
        settingsTableView.rx.setDelegate(self)
            .disposed(by: dispose)
        dataSource.titleForHeaderInSection = { dataSource, indexPath in
            dataSource[indexPath].model.title
        }
        settingsTableView.rx.modelSelected(SettingsItem.self)
            .subscribe(onNext: { [self] model in
                switch model {
                case .endtimeOfTask, .numberOfTask, .priorityOfTask,
                     .help, .share, .developerAccount, .contact:
                    processOfTaskTypeInModelSelected(item: model)
                case .deleteTask:
                    presentAlertRelatedDeleteTypeInDidSelectRowAt(title: "警告", message: "作成済みのタスクリストを削除してもよろしいですか？") { [self] in
                        // タスクリストを削除
                        viewModel.todoLogicModel.deleteTodoList()
                        viewModel.setup()
                        self.processAfterDeletedData(alertMessage: "タスクリストを削除しました")
                    }
                case .deleteAll:
                    presentAlertRelatedDeleteTypeInDidSelectRowAt(title: "警告", message: "本アプリの全データを削除しますが、よろしいですか？") { [self] in
                        // Realmの全データを削除
                        viewModel.todoLogicModel.deleteAllData()
                        viewModel.setup()
                        self.processAfterDeletedData(alertMessage: "全データを削除しました")
                        // UserDefaultの日付をデフォルト値にリセット
                        UserDefaults.standard.set(Date(timeIntervalSince1970: -1.0), forKey: IdentifierType.dateWhenDidEndTask)
                    }
                }
            }).disposed(by: dispose)
    }

    private func processOfTaskTypeInModelSelected(item: SettingsItem) {
        if item == .endtimeOfTask || item == .numberOfTask || item == .priorityOfTask {
            if !viewModel.todoLogicModel.isEmptyOfDataInRealm {
                if !viewModel.todoLogicModel.isEmptyOfTodoList {
                    let alert = UIAlertController(title: "エラー", message: "タスクリストを削除してから再設定してください", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    present(alert, animated: true, completion: nil)
                    return
                }
            }
        }

        guard let customAlertVC = R.storyboard.customAlert.instantiateInitialViewController() else {
            return
        }

        switch item {
        case .endtimeOfTask:
            customAlertVC.setInitializeFromAnotherVC(pickerMode: .endtimeOfTask, selectedEndTime: (self.endtimeValueOfTask), selectedNumber: self.numberValueOfTask)
            UIApplication.topViewController()?.present(customAlertVC, animated: true, completion: nil)
        case .numberOfTask:
            customAlertVC.setInitializeFromAnotherVC(pickerMode: .numberOfTask, selectedEndTime: (self.endtimeValueOfTask), selectedNumber: self.numberValueOfTask)
            UIApplication.topViewController()?.present(customAlertVC, animated: true, completion: nil)
        case .priorityOfTask:
            break
        case .help:
            performSegue(withIdentifier: R.segue.settingsViewController.settingHelp, sender: nil)
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
        case .deleteTask:
            break
        case .deleteAll:
            break
        }
    }

    private func processAfterDeletedData(alertMessage: String) {
        // 通知類を削除
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "notification"), object: nil)
        // 削除したことを通知
        let resultAlert = UIAlertController(title: "削除", message: alertMessage, preferredStyle: .alert)
        resultAlert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            self.settingsTableView.reloadData()
        })
        self.present(resultAlert, animated: true, completion: nil)
    }

    private func presentAlertRelatedDeleteTypeInDidSelectRowAt(title: String, message: String, completionOfOkAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { _ in
            completionOfOkAction()
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @IBAction private func unwindToSettingVC(_ unwindSegue: UIStoryboardSegue) {
        if let customAlertVC = R.segue.customAlertViewController.unwindToSettingsVCFromCustomAlert(segue: unwindSegue)?.source,
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
