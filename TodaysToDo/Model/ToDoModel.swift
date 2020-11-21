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
    let todoList = List<String>()
    // 全タスクリストのデータをまとめたもの
    let taskListDatas = List<TaskListData>()
    // 今週
    var totalOfCompletedTaskInThisWeek:[Date:Int] = [:]
    // 今月
    var totalOfCompletedTaskInThisMonth:[Date:Int] = [:]
    // 今年
    var totalOfCompletedTaskInThisYear:[Date:Int] = [:]
    // 達成率
    var percentOfComplete = 0
    // モデルID
    @objc dynamic var id: Int = 1

    override class func primaryKey() -> String? {
        "id"
    }
}

// 各日のタスクデータ
class TaskListData: Object {
    // 日付
    private let date: Date!
    // 達成したタスクの数
    private let numberOfCompletedTask: Int!

    init(date: Date, number: Int) {
        self.date = date
        self.numberOfCompletedTask = number
    }

    @available(*, unavailable)
    required init() {
        fatalError("init() has not been implemented")
    }
}

// Realmのデータ（全ファイルで共有）
enum RealmResults {
    static var sharedInstance: Results<ToDoModel> = realm.objects(ToDoModel.self)
}
