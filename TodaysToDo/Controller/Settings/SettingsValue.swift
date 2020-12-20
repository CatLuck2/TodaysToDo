//
//  SettingsValue.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/14.
//

import Foundation

final class SettingsValue: NSObject, NSSecureCoding {

    static var supportsSecureCoding: Bool = true

    var endTimeOfTask: (x: Int?, y: Int?) = (0, 0)
    var numberOfTask: Int = 0
    var priorityOfTask: Bool = false

    override init() {
        super.init()
    }

    required init(coder decoder: NSCoder) {
        if let x = decoder.decodeObject(forKey: IdentifierType.tupleX) as! Int?, let y = decoder.decodeObject(forKey: IdentifierType.tupleY) as! Int? {
            endTimeOfTask = (x, y)
        }
        if let numberOfTask = decoder.decodeInteger(forKey: IdentifierType.number) as Int? {
            self.numberOfTask = numberOfTask
        }
        self.priorityOfTask = decoder.decodeBool(forKey: IdentifierType.priority)
    }

    func encode(with coder: NSCoder) {
        coder.encode(endTimeOfTask.x, forKey: IdentifierType.tupleX)
        coder.encode(endTimeOfTask.y, forKey: IdentifierType.tupleY)
        coder.encode(numberOfTask, forKey: IdentifierType.number)
        coder.encode(priorityOfTask, forKey: IdentifierType.priority)
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
        UserDefaults.standard.set(settingsValueData, forKey: IdentifierType.settingsValueData)
    }

    // UserDefaultから取得
    func readSettingsValue() -> SettingsValue {
        let dataInUD = UserDefaults.standard.object(forKey: IdentifierType.settingsValueData)
        do {
            let settingsValueData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataInUD as! Data) as! SettingsValue
            return settingsValueData
        } catch {
            fatalError("Error of reading data in UserDefault")
        }
    }
}
