//
//  SettingsValue.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/14.
//

import Foundation

class SettingsValue: NSObject, NSCoding {

    private var endTimeOfTask: (x: Int?, y: Int?) = (0, 0)
    private var numberOfTask: Int = 0
    private var priorityOfTask: Bool = false

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

}
