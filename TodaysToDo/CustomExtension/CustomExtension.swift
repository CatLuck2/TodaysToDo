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
        locale = Locale.current
        timeZone = TimeZone.current
        if let currentDate = date(from: string(from: Date())) {
            return currentDate
        } else {
            return Date(timeIntervalSince1970: 0)
        }
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
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return [] as [Date]
        }
        guard let startOfWeek = gregorian.date(byAdding: .day, value: 1, to: sunday) else {
            return [] as [Date]
        }

        for d in 0...6 {
            guard let day = date(byAdding: .day, value: d, to: startOfWeek) else {
                return [] as [Date]
            }
            days.append(day)
        }
        return days
    }
    func getFirstDayOfMonth(date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        guard let startOfMonth = self.date(from: components) else {
            return Date(timeIntervalSince1970: 0)
        }
        return startOfMonth
    }
    func getAllDaysOfMonth(date: Date) -> [Date] {
        var days: [Date]! = []
        guard let rangeOfThisMonth = self.range(of: .day, in: .month, for: date) else {
            return [] as [Date]
        }
        guard let startOfMonth = self.date(from: dateComponents([.year, .month], from: date)) else {
            return [] as [Date]
        }
        for d in 0..<rangeOfThisMonth.count {
            guard let day = self.date(byAdding: .day, value: d, to: startOfMonth) else {
                return [] as [Date]
            }
            days.append(day)
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
            guard let dateMonth = self.date(from: dataComponent) else {
                return [] as [Date]
            }
            months.append(dateMonth)
        }
        return months
    }
}
