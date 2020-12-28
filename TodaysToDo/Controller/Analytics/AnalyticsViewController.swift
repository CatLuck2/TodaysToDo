//
//  AnalyticsViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RxSwift
import RxCocoa

final class AnalyticsViewController: UIViewController {

    @IBOutlet private weak var graphSegment: UISegmentedControl!
    @IBOutlet private weak var graphScrollView: UIScrollView!
    @IBOutlet private weak var graphContentView: UIView!
    @IBOutlet private weak var totalCompletedTaskLabel: UILabel!
    @IBOutlet private weak var rateCompletedTaskLabel: UILabel!
    @IBOutlet private weak var graphContentViewWidth: NSLayoutConstraint!

    private var viewModel = AnalyticsViewModel(todoLogicModel: SharedModel.todoListLogicModel)
    private let dispose = DisposeBag()
    // グラフ
    private var graphView = GraphView()
    private var width: CGFloat = 0
    private var height: CGFloat = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalCompletedTaskLabel.text = "\(viewModel.getNumOfCompletedTask())個"
        rateCompletedTaskLabel.text = "\(viewModel.getAverageValue())%"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        graphSegment.rx.selectedSegmentIndex.asObservable()
            .subscribe(onNext: { index in
                self.processOfSegmentControl(index: index)
            }).disposed(by: dispose)

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!

        width = self.view.frame.width
        height = graphContentView.frame.height
        graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .week, data: viewModel.createWeekDatas())
        // graphContentViewに載せる
        graphContentView.addSubview(graphView)
        // graphContentViewをグラフの横幅に合わせる
        graphContentViewWidth.constant = CGFloat(width)
        // スクロール領域をgraphContentViewに調整
        graphScrollView.contentSize = graphContentView.frame.size
    }

    private func processOfSegmentControl(index: Int) {
        // 既存のグラフを削除
        for view in graphContentView.subviews {
            view.removeFromSuperview()
        }
        switch index {
        case 0: // 今週
            graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .week, data: viewModel.createWeekDatas())
        case 1: // 今月
            graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .month, data: viewModel.createMonthDatas())
        case 2: // 今年
            graphView = GraphView(frame: CGRect(x: 0, y: 0, width: width, height: height), graphtype: .year, data: viewModel.createYearDatas())
        default:
            break
        }
        graphContentView.addSubview(graphView)
    }
}
