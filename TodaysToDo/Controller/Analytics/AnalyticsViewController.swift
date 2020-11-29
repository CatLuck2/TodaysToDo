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
    //    let graphView = GraphView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTotalCompletedTaskLabel()
        setRateCompletedTaskLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = 320
        let height = 250
        let graphView = AnotherGraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), data: createWeekDatas())
        // graphContentViewに載せる
        graphContentView.addSubview(graphView)
        // graphContentViewをグラフの横幅に合わせる
        graphContentViewWidth.constant = CGFloat(width)
        // スクロール領域をgraphContentViewに調整
        graphScrollView.contentSize = graphContentView.frame.size
    }

    //    private func drawLineGraph() {
    //        switch graphSegment.selectedSegmentIndex {
    //        case 0: //今週
    //            graphView.drawWeekLineGraph(screenWidth: self.view.frame.width)
    //        case 1: //今月
    //            graphView.drawMonthLineGraph(screenWidth: self.view.frame.width)
    //        case 2: //今年
    //            graphView.drawYearLineGraph(screenWidth: self.view.frame.width)
    //        default:
    //            break
    //        }
    //        // graphContentViewをグラフの横幅に合わせる
    //        graphContentViewWidth.constant = graphView.checkWidth() + 20
    //        // スクロール領域をgraphContentViewに調整
    //        graphScrollView.contentSize = graphContentView.frame.size
    //    }

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
                            if value.key == Date().getDayOfTheWeek(date: day1) {
                                // 合致した曜日の値を更新
                                data[i][Date().getDayOfTheWeek(date: day1)]
                                    = day2.numberOfCompletedTask
                            }
                        }
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
        // 描画されたグラフを更新
        //        graphView.setNeedsDisplay()
        //        // 横目盛りを更新
        //        for view in graphView.subviews {
        //            view.removeFromSuperview()
        //        }
        //        drawLineGraph()
    }

}
