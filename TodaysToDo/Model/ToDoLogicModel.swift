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
            let array = Array(realm.objects(TestToDoModel.self))
            todoItems.accept(array)
        }
    }
}
