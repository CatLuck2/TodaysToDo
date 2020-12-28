//
//  ToDoModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import RealmSwift

private var realm = try! Realm()

class ToDoModel: Object {
    var todoList = List<String>()
    @objc dynamic var date: Date! = nil
    @objc dynamic var numberOfTask: Int = 0
    @objc dynamic var numberOfCompletedTask: Int = 0
    @objc dynamic var id: Int = 1
    override class func primaryKey() -> String? {
        "id"
    }
}
