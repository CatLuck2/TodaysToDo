//
//  CustomExtension.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/22.
//

import Foundation
import RealmSwift

extension DateFormatter {
    func getCurrentDate() -> Date {
        dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms", options: 0, locale: Locale(identifier: "ja_JP"))
        timeZone = TimeZone(identifier: "UTC")!
        let st = string(from: Date())
        return date(from: st)!
    }
    func getDayOfWeekByStr(date: Date) -> String {
        // Localeがないと日で出力されない
        locale = Locale(identifier: "ja_JP")
        var calendar = Calendar.current
        // TimeZoneがないと正しい曜日が出力されない
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let dw = calendar.component(.weekday, from: date)
        return shortWeekdaySymbols[dw - 1]
    }
    func getDayOfMonthByStr(date: Date) -> String {
        dateFormat = "d"
        locale = Locale(identifier: "ja_JP")
        return string(from: date)
    }
    func getMonthOfYearByStr(date: Date) -> String {
        dateFormat = "M"
        locale = Locale(identifier: "ja_JP")
        return string(from: date)
    }
}

extension Calendar {
    var getAllDaysOfWeek: [Date] {
        var days: [Date]! = []

        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let startOfWeek = gregorian.date(byAdding: .day, value: 1, to: sunday)!

        for d in 0...6 {
            let day = date(byAdding: .day, value: d, to: startOfWeek)
            days.append(day!)
        }
        return days
    }
    func getFirstDayOfMonth(date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        let startOfMonth = self.date(from: components)
        return startOfMonth!
    }
    func getAllDaysOfMonth(date: Date) -> [Date] {
        var days: [Date]! = []
        let rangeOfThisMonth = self.range(of: .day, in: .month, for: date)
        let startOfMonth = self.date(from: dateComponents([.year, .month], from: date))!
        for d in 0..<rangeOfThisMonth!.last! {
            let day = self.date(byAdding: .day, value: d, to: startOfMonth)
            days.append(day!)
        }
        return days
    }
    //年を取得
    func getAllMonthsOfYear(date: Date) -> [Date] {
        var months: [Date] = []
        for month in 1...12 {
            var dataComponent = DateComponents()
            dataComponent.year = component(.year, from: date)
            dataComponent.month = month
            months.append(self.date(from: dataComponent)!)
        }
        return months
    }
}
