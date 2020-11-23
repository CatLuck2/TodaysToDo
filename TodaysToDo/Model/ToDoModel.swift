//
//  ToDoModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import RealmSwift

private var realm = try! Realm()

class ToDoModel: Object {
    // タスクリスト
    var todoList = List<String>()
    // 全タスクリストのデータをまとめたもの
    var taskListDatas = List<TaskListData>()
    // 今週
    var weekList = List<TaskListData>()
    // 今月
    var monthList = List<TaskListData>()
    // 今年
    var yearList = List<TotalOfCompletedTaskInYear>()
    // 達成率
    @objc dynamic var percentOfComplete = 0
    // モデルID
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}

// 各日のタスクデータ
class TaskListData: Object {
    // 日付
    @objc dynamic var date: Date! = nil
    // 達成したタスクの数
    @objc dynamic var numberOfCompletedTask: Int = 0
}

// 今年
class TotalOfCompletedTaskInYear: Object {
    @objc dynamic var monthOfYear: Date! = nil
    @objc dynamic var total: Int = 0
}

// Realmのデータ（全ファイルで共有）
enum RealmResults {
    static var sharedInstance: Results<ToDoModel> = realm.objects(ToDoModel.self)
}
