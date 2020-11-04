//
//  ToDoModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import RealmSwift

private var realm = try! Realm()

class ToDoModel: Object {
    let todoList = List<String>()
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}

class RealmResults {
    static var sharedInstance: Results<ToDoModel> = realm.objects(ToDoModel.self)
}
