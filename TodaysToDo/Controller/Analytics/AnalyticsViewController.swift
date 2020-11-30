//
//  AnalyticsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit

class AnalyticsViewController: UIViewController {

    @IBOutlet private weak var graphSegment: UISegmentedControl!
    @IBOutlet private weak var graphScrollView: UIScrollView!
    @IBOutlet private weak var graphContentView: UIView!
    @IBOutlet private weak var totalCompletedTaskLabel: UILabel!
    @IBOutlet private weak var rateCompletedTaskLabel: UILabel!
    @IBOutlet private weak var graphContentViewWidth: NSLayoutConstraint!

    // グラフ
    var graphView = GraphView()
    var width: CGFloat = 0
    var height: CGFloat = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTotalCompletedTaskLabel()
        setRateCompletedTaskLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.width
        height = graphContentView.frame.height
        graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .week, data: createWeekDatas())
        // graphContentViewに載せる
        graphContentView.addSubview(graphView)
        // graphContentViewをグラフの横幅に合わせる
        graphContentViewWidth.constant = CGFloat(width)
        // スクロール領域をgraphContentViewに調整
        graphScrollView.contentSize = graphContentView.frame.size
    }

    private func createWeekDatas() -> [[String: Int]] {
        var data = [
            ["日": 0],
            ["月": 0],
            ["火": 0],
            ["水": 0],
            ["木": 0],
            ["金": 0],
            ["土": 0]
        ]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        for day1 in Date().allDaysOfWeek {
            for day2 in RealmResults.sharedInstance[0].weekList {
                if calendar.isDate(day1, inSameDayAs: day2.date!) {
                    // dataの各要素をそれぞれ取り出す
                    for i in 0..<data.count {
                        // 取り出した要素のキーと値を取り出す
                        for (_, value) in data[i].enumerated() {
                            // day1の曜日と合致するか確認
                            if value.key == day1.dayOfWeekByStr {
                                // 合致した曜日の値を更新
                                data[i][day1.dayOfWeekByStr] = day2.numberOfCompletedTask
                            }
                        }
                    }
                }
            }
        }
        return data
    }

    private func createMonthDatas() -> [[String: Int]] {
        var data = [[String: Int]]()
        for day in Date().allDaysOfMonth {
            data.append([day.dayOfMonthByStr: 0])
        }
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        for day1 in Date().allDaysOfMonth {
            for day2 in RealmResults.sharedInstance[0].monthList {
                if calendar.isDate(day1, inSameDayAs: day2.date!) {
                    // dataの各要素をそれぞれ取り出す
                    for i in 0..<data.count {
                        // 取り出した要素のキーと値を取り出す
                        for (_, value) in data[i].enumerated() {
                            // day1の日と合致するか確認
                            if value.key == day1.dayOfMonthByStr {
                                // 合致した日の値を更新
                                data[i][day1.dayOfMonthByStr]
                                    = day2.numberOfCompletedTask
                            }
                        }
                    }
                }
            }
        }
        return data
    }

    private func createYearDatas() -> [[String: Int]] {
        var data = [
            ["1": 0],
            ["2": 0],
            ["3": 0],
            ["4": 0],
            ["5": 0],
            ["6": 0],
            ["7": 0],
            ["8": 0],
            ["9": 0],
            ["10": 0],
            ["11": 0],
            ["12": 0]
        ]
        for monthDate in RealmResults.sharedInstance[0].yearList {
            // dataの各要素をそれぞれ取り出す
            for i in 0..<data.count {
                // 取り出した要素のキーと値を取り出す
                for (_, value) in data[i].enumerated() {
                    // day1の日と合致するか確認
                    if value.key == monthDate.monthOfYear.monthOfYearByStr {
                        // 合致した日の値を更新
                        data[i][monthDate.monthOfYear.monthOfYearByStr]
                            = monthDate.total
                    }
                }
            }
        }
        return data
    }

    private func setTotalCompletedTaskLabel() {
        var total: Int = 0
        for task in RealmResults.sharedInstance[0].taskListDatas {
            total += task.numberOfCompletedTask
        }
        totalCompletedTaskLabel.text = "\(total)個"
    }

    private func setRateCompletedTaskLabel() {
        rateCompletedTaskLabel.text = "\(RealmResults.sharedInstance[0].percentOfComplete)%"
    }

    @IBAction private func graphSegment(_ sender: UISegmentedControl) {
        // 既存のグラフを削除
        for view in graphContentView.subviews {
            view.removeFromSuperview()
        }
        switch graphSegment.selectedSegmentIndex {
        case 0: //今週
            graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .week, data: createWeekDatas())
        case 1: //今月
            graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .month, data: createMonthDatas())
        case 2: //今年
            graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .year, data: createYearDatas())
        default:
            break
        }
        graphContentView.addSubview(graphView)
    }

}
