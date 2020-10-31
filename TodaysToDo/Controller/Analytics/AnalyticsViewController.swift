//
//  AnalyticsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit

class AnalyticsViewController: UIViewController {

    @IBOutlet weak var graphSegment: UISegmentedControl!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var totalCompletedTaskLabel: UILabel!
    @IBOutlet weak var rateCompletedTaskLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let graphView = GraphView() //グラフを表示するクラス
        self.graphView.addSubview(graphView) //グラフをスクロールビューに配置
        graphView.drawLineGraph() //グラフ描画開始
    }

    @IBAction func graphSegment(_ sender: UISegmentedControl) {
    }

}
