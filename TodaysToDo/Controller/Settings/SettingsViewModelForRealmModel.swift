//
//  SettingsViewModelForRealmModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/27.
//

import Foundation

class SettingsViewModelForRealmModel {
    private let todoLogicModel: ToDoLogicModel

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func getIsEmptyOfDataInRealm() -> Bool {
        todoLogicModel.isEmptyOfDataInRealm
    }

    func getIsEmptyOfTodoList() -> Bool {
        todoLogicModel.isEmptyOfTodoList
    }

    func deleteTodoList() {
        todoLogicModel.deleteTodoList()
    }

    func deleteAllData() {
        todoLogicModel.deleteAllData()
    }

    func getStringOfMinutes(number: Int) -> String {
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
}
