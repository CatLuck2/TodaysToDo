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
    // 作成したタスクの数
    @objc dynamic var numberOfTask: Int = 0
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
    // Realmに1つでも値か空の変数が保存されてる？
    static var isEmptyOfDataInRealm: Bool {
        RealmResults.sharedInstance.isEmpty
    }
    // sharedInstance[0]の中に値がある？
    static var isEmptyOfTodoList: Bool {
        RealmResults.sharedInstance[0].todoList.isEmpty
    }

    static var isEmptyOfTaskListDatas: Bool {
        RealmResults.sharedInstance[0].taskListDatas.isEmpty
    }

    static var isEmptyOfWeekList: Bool {
        RealmResults.sharedInstance[0].weekList.isEmpty
    }

    static var isEmptyOfMonthList: Bool {
        RealmResults.sharedInstance[0].monthList.isEmpty
    }

    static var isEmptyOfYearList: Bool {
        RealmResults.sharedInstance[0].yearList.isEmpty
    }
}
