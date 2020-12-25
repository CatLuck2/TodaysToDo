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

    var todoObservable: Observable<[TestToDoModel]> {
        todoLogicModel.todoItemsObservable
    }

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }
}
