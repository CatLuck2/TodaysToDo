//
//  AnalyticsViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation

class AnalyticsViewModel {

    private var todoLogicModel: ToDoLogicModel! = nil

    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func getTestToDoModels() -> [TestToDoModel] {
        todoLogicModel.getTestToDoModels()
    }

    func createWeekGraphData() -> [[Any]] {
        var graphData:[[Any]] = []
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

    func createMonthGraphData() -> [[Any]] {
        var graphData:[[Any]] = []
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

    func createYearGraphData() -> [[Any]] {
        var graphData:[[Any]] = []
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
            graphData.append([month, totalOfInMonth])
        }
        return graphData
    }
}
