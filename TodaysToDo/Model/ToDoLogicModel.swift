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

    init() {
        if realm.objects(TestToDoModel.self).isEmpty == false {
            todoItems.accept(Array(realm.objects(TestToDoModel.self)))
        }
    }

    func addTodoList(todoList: [String]) {
        let newTodoListForRealm: [String: Any] = [IdentifierType.realmModelID: todoList]
        let model = TestToDoModel(value: newTodoListForRealm)
        try! realm.write {
            realm.add(model, update: .all)
        }
    }
}
