//
//  ToDoLogicModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

enum SharedModel {
    static let todoListLogicModel = ToDoLogicModel()
}

final class ToDoLogicModel {
    private let realm = try! Realm()
    private let todoItems = BehaviorRelay<[ToDoModel]>(value: [])
    var todoItemsObservable: Observable<[ToDoModel]> {
        todoItems.asObservable()
    }
    var isEmptyOfDataInRealm: Bool {
        // Realmに1つでも値か空の変数が保存されてる？
        return todoItems.value.isEmpty
    }
    var isEmptyOfTodoList: Bool {
        let latestNum = todoItems.value.count - 1
        return todoItems.value[latestNum].todoList.isEmpty
    }
    var isEmptyOfTaskListData: Bool {
        let latestNum = todoItems.value.count - 1
        return (todoItems.value[latestNum].numberOfTask == 0)
    }

    init() {
        if realm.objects(ToDoModel.self).isEmpty == false {
            todoItems.accept(Array(realm.objects(ToDoModel.self)))
        }
    }

    func addTodoList(todoList: [String]) {
        let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: todoList]
        let model = ToDoModel(value: newTodoListForRealm)
        try! realm.write {
            realm.add(model)
        }
    }

    func saveTaskListData(date: Date, numOfTask: Int, numOfCompletedTask: Int) {
        let latestNum = todoItems.value.count - 1
        try! realm.write {
            todoItems.value[latestNum].todoList.removeAll()
            todoItems.value[latestNum].date = date
            todoItems.value[latestNum].numberOfTask = numOfTask
            todoItems.value[latestNum].numberOfCompletedTask = numOfCompletedTask
        }
    }

    func readTestToDoModel() {
        todoItems.accept(Array(realm.objects(ToDoModel.self)))
    }

    func updateTodoList(todoElement: [String]) {
        let latestNum = todoItems.value.count - 1
        try! realm.write {
            todoItems.value[latestNum].todoList.removeAll()
            todoItems.value[latestNum].todoList.append(objectsIn: todoElement)
        }
    }

    func deleteTodoList() {
        let latestNum = todoItems.value.count - 1
        try! realm.write {
            todoItems.value[latestNum].todoList.removeAll()
        }
    }

    func deleteElementInTodoList(row: Int) {
        let latestNum = todoItems.value.count - 1
        try! realm.write {
            todoItems.value[latestNum].todoList.remove(at: row)
        }
    }

    func deleteAllData() {
        var array = todoItems.value
        array.removeAll()
        todoItems.accept(array)
        try! realm.write {
            realm.deleteAll()
        }
    }

    func getCount() -> Int {
        let latestNum = todoItems.value.count - 1
        return todoItems.value[latestNum].todoList.count
    }

    func getTodoList() -> [String] {
        let latestNum = todoItems.value.count - 1
        return Array(todoItems.value[latestNum].todoList)
    }

    func getTestToDoModels() -> [ToDoModel] {
        todoItems.value
    }
}
