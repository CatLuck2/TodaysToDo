//
//  CustomExtension.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/22.
//

import Foundation
import RealmSwift

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    var allDaysOfWeek: [Date] {
        var days: [Date]! = []
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        for d in 0...6 {
            let day = calendar.date(byAdding: .day, value: d, to: startOfWeek!)
            days.append(day!)
        }
        return days
    }
    var firstDayOfMonth: Date {
        var calender = Calendar.current
        calender.timeZone = TimeZone(identifier: "UTC")!
        let components = calender.dateComponents([.year, .month], from: self)
        let startOfMonth = calender.date(from: components)
        return startOfMonth!
    }
    var allDaysOfMonth: [Date] {
        var days: [Date]! = []
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let rangeOfThisMonth = calendar.range(of: .day, in: .month, for: self)
        for d in 0..<rangeOfThisMonth!.last! {
            let day = calendar.date(byAdding: .day, value: d, to: firstDayOfMonth)
            days.append(day!)
        }
        return days
    }
    var allMonthsOfYear: [Date] {
        var months: [Date] = []
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        for month in 1...12 {
            var dataComponent = DateComponents()
            dataComponent.year = calendar.component(.year, from: self)
            dataComponent.month = month
            months.append(calendar.date(from: dataComponent)!)
        }
        return months
    }
    func getCurrentDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms", options: 0, locale: Locale(identifier: "ja_JP"))
        let st = dateFormatter.string(from: Date())
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        return dateFormatter.date(from: st)!
    }
}