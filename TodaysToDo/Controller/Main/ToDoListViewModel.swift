//
//  ToDoListViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class ToDoListViewModel {
    // セルのタイプ
    let itemList = BehaviorRelay<[ToDoListModel]>(value: [])
    var itemListObservable: Observable<[ToDoListModel]> {
        itemList.asObservable()
    }

    // Realmとのやりとり
    private let todoLogicModel: ToDoLogicModel
    var testToDoModelObservable: Observable<[TestToDoModel]> {
        todoLogicModel.todoItemsObservable
    }

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func add(todoList: [String]) {
        todoLogicModel.addTodoList(todoList: todoList)
    }

    func updateTodoList(todoElement: [String]) {
        todoLogicModel.updateTodoList(todoElement: todoElement)
    }
    
    func delete(row: Int) {
        todoLogicModel.deleteElementInTodoList(row: row)
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

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(model: Element.Element) {
        var array = self.value
        array.append(model)
        self.accept(array)
    }

    func update(model: Element.Element, index: Element.Index) {
        var array = self.value
        array.remove(at: index)
        array.insert(model, at: index)
        self.accept(array)
    }

    func insert(model: Element.Element, index: Element.Index) {
        var array = self.value
        array.insert(model, at: index)
        self.accept(array)
    }

    func remove(index: Element.Index) {
        var array = self.value
        array.remove(at: index)
        self.accept(array)
    }
}
