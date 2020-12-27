//
//  CustomTabBarViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/27.
//

import Foundation

class CustomTabBarViewModel {
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

    func getIsEmptyOfTaskListData() -> Bool {
        todoLogicModel.isEmptyOfTaskListData
    }
}
