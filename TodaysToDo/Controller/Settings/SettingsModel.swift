//
//  SettingsViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/23.
//

import RxSwift
import RxCocoa
import RxDataSources

typealias SettingsSectionModel = SectionModel<SettingsSection, SettingsItem>

enum SettingsSection {
    case task, other, deleteTask, deleteAll
}

enum SettingsItem {
    // task
    case endtimeOfTask, numberOfTask, priorityOfTask
    // other
    case help, share, developerAccount, contact
    // deleteTask
    case deleteTask
    // deleteAll
    case deleteAll

    var title: String? {
        switch self {
        case .endtimeOfTask:
            return "終了時刻"
        case .numberOfTask:
            return "設定数"
        case .priorityOfTask:
            return "優先順位"
        case .help:
            return "ヘルプ"
        case .share:
            return "共有"
        case .developerAccount:
            return "開発者のTwitter"
        case .contact:
            return "お問い合わせ"
        case .deleteTask:
            return "タスクリストを削除"
        case .deleteAll:
            return "タスクリストを削除"
        }
    }
}
