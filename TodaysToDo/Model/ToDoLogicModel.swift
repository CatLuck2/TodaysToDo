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
    private let todoItems = BehaviorRelay<[TestToDoModel]>(value: [])
    var todoItemsObservable: Observable<[TestToDoModel]> {
        todoItems.asObservable()
    }
    var isEmptyOfDataInRealm: Bool {
        // Realmに1つでも値か空の変数が保存されてる？
        todoItems.value.isEmpty
    }
    var isEmptyOfTodoList: Bool {
        todoItems.value[0].todoList.isEmpty
    }
    var isEmptyOfTaskListData: Bool {
        (todoItems.value[0].numberOfTask == 0)
    }

    init() {
        if realm.objects(TestToDoModel.self).isEmpty == false {
            todoItems.accept(Array(realm.objects(TestToDoModel.self)))
        }
    }

    func addTodoList(todoList: [String]) {
        let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: todoList]
        let model = TestToDoModel(value: newTodoListForRealm)
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
        todoItems.accept(Array(realm.objects(TestToDoModel.self)))
    }

    func updateTodoList(todoElement: [String]) {
        let latestNum = todoItems.value.count - 1
        try! realm.write {
            todoItems.value[latestNum].todoList.removeAll()
            todoItems.value[latestNum].todoList.append(objectsIn: todoElement)
        }
    }

    func deleteElementInTodoList(row: Int) {
        let latestNum = todoItems.value.count - 1
        try! realm.write {
            todoItems.value[latestNum].todoList.remove(at: row)
        }
    }

    func getCount() -> Int {
        todoItems.value[0].todoList.count
    }

    func getTodoList() -> [String] {
        Array(todoItems.value[0].todoList)
    }

    func getTestToDoModels() -> [TestToDoModel] {
        todoItems.value
    }
}
