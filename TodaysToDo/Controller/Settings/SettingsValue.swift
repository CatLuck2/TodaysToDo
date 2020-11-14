//
//  SettingsValue.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/14.
//

import Foundation

class SettingsValue: NSObject, NSSecureCoding {

    static var supportsSecureCoding: Bool = true

    private(set) var endTimeOfTask: (x: Int?, y: Int?) = (0, 0)
    private(set) var numberOfTask: Int = 0
    private(set) var priorityOfTask: Bool = false

    override init() {
        super.init()
    }

    required init(coder decoder: NSCoder) {
        if let x = decoder.decodeInteger(forKey: "myTupleX") as Int?, let y = decoder.decodeInteger(forKey: "myTupleY") as Int? {
            endTimeOfTask = (x, y)
        }
        if let numberOfTask = decoder.decodeInteger(forKey: "number") as Int? {
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
        guard let settingsValueData = try? NSKeyedArchiver.archivedData(withRootObject: sv, requiringSecureCoding: true) else {
            fatalError("Error of saving data in UserDefault")
        }
        UserDefaults.standard.set(settingsValueData, forKey: "settingsValueData")
    }

    // UserDefaultから取得
    func readSettingsValue() -> SettingsValue {
        let dataInUD = UserDefaults.standard.object(forKey: "settingsValueData")
        do {
            let settingsValueData = try NSKeyedUnarchiver.unarchivedObject(ofClass: SettingsValue.self, from: dataInUD as! Data)!
            return settingsValueData
        } catch {
            fatalError("Error of reading data in UserDefault")
        }
    }
}
