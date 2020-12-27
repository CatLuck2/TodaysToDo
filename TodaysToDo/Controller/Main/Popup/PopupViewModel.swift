//
//  PopupViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation

class PopupViewModel {
    private let todoLogicModel: ToDoLogicModel

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func saveTaskListData(date: Date, numOfTask: Int, numOfCompletedTask: Int) {
        todoLogicModel.saveTaskListData(date: date, numOfTask: numOfTask, numOfCompletedTask: numOfCompletedTask)
    }
}
