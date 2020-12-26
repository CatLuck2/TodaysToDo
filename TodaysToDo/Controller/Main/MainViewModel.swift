//
//  MainViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let todoLogicModel: ToDoLogicModel

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
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

    func getIsEmptyOfTaskListData() -> Bool {
        todoLogicModel.isEmptyOfTaskListData
    }
}
