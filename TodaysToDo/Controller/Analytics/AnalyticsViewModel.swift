//
//  AnalyticsViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation

class AnalyticsViewModel {

    private var todoLogicModel: ToDoLogicModel! = nil

    private let df = DateFormatter()
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func getTestToDoModels() -> [ToDoModel] {
        todoLogicModel.getTestToDoModels()
    }

    func getNumOfCompletedTask() -> Int {
        var total: Int = 0
        for task in self.getTestToDoModels() {
            total += task.numberOfCompletedTask
        }
        return total
    }

    func getAverageValue() -> Int {
        var totalOfTask: Int = 0
        var totalOfCompletedTask: Int = 0
        for task in self.getTestToDoModels() {
            totalOfTask += task.numberOfTask
            totalOfCompletedTask += task.numberOfCompletedTask
        }
        return Int((Double(totalOfCompletedTask) / Double(totalOfTask)) * 100)
    }

    var weekGraphData: [[Any]] {
        var graphData: [[Any]] = []
        // 今週の各日付、タスクの日付を比較していく
        for day in calendar.getAllDaysOfWeek {
            for taskData in getTestToDoModels() {
                // 今週の中の日付が存在する？
                if !calendar.isDate(taskData.date!, inSameDayAs: day) {
                    continue
                }
                graphData.append([taskData.date!, taskData.numberOfTask, taskData.numberOfCompletedTask])
            }
        }
        return graphData
    }

    var monthGraphData: [[Any]] {
        var graphData: [[Any]] = []
        for day in calendar.getAllDaysOfMonth(date: Date()) {
            for taskData in getTestToDoModels() {
                // 今週の中の日付が存在する？
                if !calendar.isDate(taskData.date!, inSameDayAs: day) {
                    continue
                }
                graphData.append([taskData.date!, taskData.numberOfTask, taskData.numberOfCompletedTask])
            }
        }
        return graphData
    }

    var yearGraphData: [[Any]] {
        var graphData: [[Any]] = []
        for month in calendar.getAllMonthsOfYear(date: Date()) {
            var totalOfInMonth: Int! = 0
            for taskData in getTestToDoModels() {
                // 同じ月が存在する？
                if !calendar.isDate(month, equalTo: taskData.date!, toGranularity: .month) {
                    continue
                }
                // 合致する月のタスクデータのチェック数を足していく
                totalOfInMonth += taskData.numberOfCompletedTask
            }
            graphData.append([month, totalOfInMonth!])
        }
        return graphData
    }

    func createWeekDatas() -> [[String: Int]] {
        var data: [[String: Int]] = []
        // [["日": 0] ~ ["土": 0]]を格納
        for day in Calendar.current.getAllDaysOfWeek {
            data.append([df.getDayOfWeekByStr(date: day): 0])
        }

        for day1 in calendar.getAllDaysOfWeek {
            for graphData in weekGraphData {
                if !calendar.isDate(day1, inSameDayAs: graphData[0] as! Date) {
                    continue
                }
                // dataの各要素をそれぞれ取り出す
                for i in 0..<data.count {
                    // day1の曜日と合致するか確認
                    if data[i].keys.first == df.getDayOfWeekByStr(date: day1) {
                        // 合致した曜日の値を更新
                        guard let num = graphData[1] as? Int else {
                            return [["": 0]]
                        }
                        data[i][df.getDayOfWeekByStr(date: day1)] = num
                    }
                }
            }
        }
        return data
    }

    func createMonthDatas() -> [[String: Int]] {
        var data = [[String: Int]]()
        for day in calendar.getAllDaysOfMonth(date: Date()) {
            data.append([df.getDayOfMonthByStr(date: day): 0])
        }
        for day1 in calendar.getAllDaysOfMonth(date: Date()) {
            for graphData in monthGraphData {
                if !calendar.isDate(day1, inSameDayAs: graphData[0] as! Date) {
                    continue
                }
                // dataの各要素をそれぞれ取り出す
                for i in 0..<data.count {
                    if data[i].keys.first == df.getDayOfMonthByStr(date: day1) {
                        // 合致した日の値を更新
                        guard let num = graphData[1] as? Int else {
                            return [["": 0]]
                        }
                        data[i][df.getDayOfMonthByStr(date: day1)]
                            = num
                    }
                }
            }
        }
        return data
    }

    func createYearDatas() -> [[String: Int]] {
        var data: [[String: Int]] = []
        // [["1": 0] ~ ["12": 0]]]を格納
        for month in 1...12 {
            data.append(["\(month)": 0])
        }

        for graphData in yearGraphData {
            // dataの各要素をそれぞれ取り出す
            for i in 0..<data.count {
                if data[i].keys.first == df.getMonthOfYearByStr(date: graphData[0] as! Date) {
                    // 合致した日の値を更新
                    guard let num = graphData[1] as? Int else {
                        return [["": 0]]
                    }
                    data[i][df.getMonthOfYearByStr(date: graphData[0] as! Date)]
                        = num
                }
            }
        }
        return data
    }
}
