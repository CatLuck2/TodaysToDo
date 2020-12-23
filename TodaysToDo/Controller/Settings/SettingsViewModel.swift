//
//  SettingsViewMode.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SettingsViewModel {
    private let items = BehaviorRelay<[SettingsSectionModel]>(value: [])

    var itemsObservable: Observable<[SettingsSectionModel]> {
        items.asObservable()
    }

    func setup() {
        setupItems()
    }

    private func setupItems() {
        let sections: [SettingsSectionModel] = [
            taskSection(),
            otherSection(),
            deleteTaskSection(),
            deleteAllSection()
        ]
        items.accept(sections)
    }

    private func taskSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .endtimeOfTask,
            .numberOfTask,
            .priorityOfTask
        ]
        return SettingsSectionModel(model: .task, items: items)
    }

    private func otherSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .help,
            .share,
            .developerAccount,
            .contact
        ]
        return SettingsSectionModel(model: .other, items: items)
    }

    private func deleteTaskSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .deleteTask
        ]
        return SettingsSectionModel(model: .deleteTask, items: items)
    }

    private func deleteAllSection() -> SettingsSectionModel {
        let items: [SettingsItem] = [
            .deleteAll
        ]
        return SettingsSectionModel(model: .deleteAll, items: items)
    }
}
