//
//  AnalyticsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit

class AnalyticsViewController: UIViewController {

    @IBOutlet weak var graphSegment: UISegmentedControl!
    @IBOutlet weak var graphScrollView: UIScrollView!
    @IBOutlet weak var graphContentView: UIView!
    @IBOutlet weak var totalCompletedTaskLabel: UILabel!
    @IBOutlet weak var rateCompletedTaskLabel: UILabel!

    @IBOutlet weak var graphContentViewWidthAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        let graphView = GraphView()
        graphContentView.addSubview(graphView)
        graphContentViewWidthAnchor.constant = graphView.checkWidth()
        graphView.drawLineGraph()
        graphScrollView.contentSize = graphContentView.frame.size
    }

    @IBAction func graphSegment(_ sender: UISegmentedControl) {
    }

}
