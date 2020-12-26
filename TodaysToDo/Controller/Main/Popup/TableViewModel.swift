//
//  TableViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation
import RxSwift

class TableViewModel {
    private let todoLogicModel: ToDoLogicModel

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func getTodoList() -> [String] {
        todoLogicModel.getTodoList()
    }

    func getCountOfTodoList() -> Int {
        todoLogicModel.getCount()
    }
}
