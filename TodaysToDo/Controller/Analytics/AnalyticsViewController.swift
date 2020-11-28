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
    let graphView = GraphView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTotalCompletedTaskLabel()
        setRateCompletedTaskLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // graphContentViewに載せる
        graphContentView.addSubview(graphView)
        // グラフを描画
        drawLineGraph()
    }

    private func drawLineGraph() {
        switch graphSegment.selectedSegmentIndex {
        case 0: //今週
            graphView.drawWeekLineGraph()
        case 1: //今月
            graphView.drawMonthLineGraph()
        case 2: //今年
            graphView.drawYearLineGraph()
        default:
            break
        }
        // graphContentViewをグラフの横幅に合わせる
        graphContentViewWidth.constant = graphView.checkWidth() + 20
        // スクロール領域をgraphContentViewに調整
        graphScrollView.contentSize = graphContentView.frame.size
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
        graphView.setNeedsDisplay()
        // 横目盛りを更新
        for view in graphView.subviews {
            view.removeFromSuperview()
        }
        drawLineGraph()
    }

}
