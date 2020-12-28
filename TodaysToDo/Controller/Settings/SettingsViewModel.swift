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
    let items = BehaviorRelay<[SettingsSectionModel]>(value: [])
    var todoLogicModel: ToDoLogicModel = SharedModel.todoListLogicModel
    var itemsObservable: Observable<[SettingsSectionModel]> {
        items.asObservable()
    }

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func setup() {
        setupItems()
    }

    private func setupItems() {
        if todoLogicModel.isEmptyOfDataInRealm {
            setupWithoutDeleteSection()
        } else {
            if todoLogicModel.isEmptyOfTaskListData {
                if todoLogicModel.isEmptyOfTodoList {
                    setupWithoutDeleteSection()
                } else {
                    setupWithoutDeleteAllDataSection()
                }
            } else {
                if todoLogicModel.isEmptyOfTodoList {
                    setupWithoutDeleteTaskSection()
                } else {
                    setupAllSection()
                }
            }
        }
    }

    private func setupAllSection() {
        let sections: [SettingsSectionModel] = [
            taskSection(),
            otherSection(),
            deleteTaskSection(),
            deleteAllSection()
        ]
        items.accept(sections)
    }

    private func setupWithoutDeleteTaskSection() {
        let sections: [SettingsSectionModel] = [
            taskSection(),
            otherSection(),
            deleteAllSection()
        ]
        items.accept(sections)
    }

    private func setupWithoutDeleteAllDataSection() {
        let sections: [SettingsSectionModel] = [
            taskSection(),
            otherSection(),
            deleteTaskSection()
        ]
        items.accept(sections)
    }

    private func setupWithoutDeleteSection() {
        let sections: [SettingsSectionModel] = [
            taskSection(),
            otherSection()
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
