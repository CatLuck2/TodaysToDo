//
//  MainViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation

class MainViewModel {
    private let todoLogicModel: ToDoLogicModel

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func read() {
        todoLogicModel.readTestToDoModel()
    }

    func getCountOfTodoList() -> Int {
        todoLogicModel.getCount()
    }

    func getTodoList() -> [String] {
        todoLogicModel.getTodoList()
    }

    func getIsEmptyOfDataInRealm() -> Bool {
        todoLogicModel.isEmptyOfDataInRealm
    }

    func getIsEmptyOfTodoList() -> Bool {
        todoLogicModel.isEmptyOfTodoList
    }
}
