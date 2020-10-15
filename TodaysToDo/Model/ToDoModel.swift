//
//  ToDoModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit
import RealmSwift

class ToDoModel: Object {
    let toDoList = List<String>()
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}
