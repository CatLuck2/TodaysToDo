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
    case task
    case other
    case deleteTask
    case deleteAll

    var headerHeight: CGFloat {
        return 40.0
    }

    var title: String? {
        switch self {
        case .task:
            return "タスク"
        case .other:
            return "その他"
        case .deleteTask:
            return "タスクリスト削除"
        case .deleteAll:
            return "全データ削除"
        }
    }
}

enum SettingsItem {
    // task
    case endtimeOfTask
    case numberOfTask
    case priorityOfTask
    // other
    case help
    case share
    case developerAccount
    case contact
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
            return "全データを削除"
        }
    }
}
