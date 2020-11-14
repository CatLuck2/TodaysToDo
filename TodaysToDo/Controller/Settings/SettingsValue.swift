//
//  SettingsValue.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/14.
//

import Foundation

class SettingsValue: NSObject, NSCoding {

    private(set) var endTimeOfTask: (x: Int, y: Int) = (0, 0)
    private(set) var numberOfTask: Int = 0
    private(set) var priorityOfTask: Bool = false

    override init() {
        super.init()
    }

    required init(coder decoder: NSCoder) {
        if let x = decoder.decodeObject(forKey: "myTupleX") as! Int?, let y = decoder.decodeObject(forKey: "myTupleY") as! Int? {
            endTimeOfTask = (x, y)
        }
        if let numberOfTask = decoder.decodeObject(forKey: "number") as? Int {
            self.numberOfTask = numberOfTask
        }
        self.priorityOfTask = decoder.decodeBool(forKey: "priority")
    }

    func encode(with coder: NSCoder) {
        coder.encode(endTimeOfTask.x, forKey: "myTupleX")
        coder.encode(endTimeOfTask.y, forKey: "myTupleY")
        coder.encode(numberOfTask, forKey: "number")
        coder.encode(priorityOfTask, forKey: "priority")
    }

    // UserDetaultに保存
    func saveSettingsValue(endTime: (Int, Int), number: Int, priority: Bool) {
        // データ作成
        let sv = SettingsValue()
        sv.endTimeOfTask = endTime
        sv.numberOfTask = number
        sv.priorityOfTask = priority
        // UserDefaultに保存
        let ud = UserDefaults.standard
        do {
            let settingsValueData = try NSKeyedArchiver.archivedData(withRootObject: sv, requiringSecureCoding: false)
            ud.set(settingsValueData, forKey: "settingsValueData")
        } catch {
            fatalError("Error of saving data in UserDefault")
        }
    }

    // UserDefaultから取得
    func readSettingsValue() -> SettingsValue {
        let ud = UserDefaults.standard
        do {
            let settingsValueData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(ud.object(forKey: "settingsValueData") as! Data) as! SettingsValue
            return settingsValueData
        } catch {
            fatalError("Error of reading data in UserDefault")
        }
    }
}
