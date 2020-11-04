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

    override func viewDidLoad() {
        super.viewDidLoad()
        // グラフを作成
        let graphView = GraphView()
        // graphContentViewに載せる
        graphContentView.addSubview(graphView)
        // グラフを描画
        graphView.drawLineGraph()
        // graphContentViewをグラフの横幅に合わせる
        graphContentViewWidth.constant = graphView.checkWidth() + 20
        // スクロール領域をgraphContentViewに調整
        graphScrollView.contentSize = graphContentView.frame.size
    }

    @IBAction private func graphSegment(_ sender: UISegmentedControl) {
    }

}
