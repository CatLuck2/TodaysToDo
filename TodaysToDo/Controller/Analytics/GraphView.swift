//
//  AnotherGraphView.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/29.
//

import UIKit

enum GraphType {
    case week, month, year
}

class GraphView: UIView {

    private var df = DateFormatter()
    private var graphType: GraphType!
    private var data = [[String: Int]]()
    private var context: CGContext!
    private let padding: CGFloat = 30
    private var graphWidth: CGFloat = 0
    private var graphHeight: CGFloat = 0
    private var axisWidth: CGFloat = 0
    private var axisHeight: CGFloat = 0
    private var everest: CGFloat = 0

    // Graph Styles
    var showLines = true
    var showPoints = true
    var linesColor = UIColor.lightGray
    var labelFont = UIFont.systemFont(ofSize: 10)

    var xMargin: CGFloat = 20
    var originLabelText: String?

    private var isThereSameDayOfWeek = false

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(frame: CGRect, graphtype: GraphType, data: [[String: Int]]) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.data = data
        self.graphType = graphtype
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        context = UIGraphicsGetCurrentContext()

        // Graph size
        graphWidth = (rect.size.width - padding) - 10
        graphHeight = rect.size.height - 40
        axisWidth = rect.size.width - 10
        axisHeight = (rect.size.height - padding) - 10

        // Lets work out the highest value and round to the nearest 25.
        // This will be used to work out the position of each value
        // on the Y axis, it essentialy reperesents 100% of Y
        for (index, point) in data.enumerated() {
            let keys = Array(data[index].keys)
            let currKey = keys.first!
            if CGFloat(point[currKey]!) > everest {
                switch graphType {
                case .week, .month:
                    everest = CGFloat(Int(ceilf(Float(point[currKey]!) / 5) * 5))
                case .year:
                    everest = CGFloat(Int(ceilf(Float(point[currKey]!) / 160) * 160))
                default:
                    break
                }
            }
        }
        if everest == 0 {
            everest = 25
        }

        // X軸線を描画
        drawXAxisPath(rect: rect)
        // Y軸線を描画
        drawYAxisPath(rect: rect)
        // Y軸の値、値を示す線、を描画
        drawYLinePath(rect: rect)
        // 始点を描画
        drawAllLinePath()

        // ???
        if originLabelText != nil {
            addSubViewOriginLabel()
        }
    }

    private func drawXAxisPath(rect: CGRect) {
        // X軸線を描画
        let xAxisPath = CGMutablePath()
        xAxisPath.move(to: CGPoint(x: padding, y: rect.size.height - 31))
        xAxisPath.addLine(to: CGPoint(x: axisWidth, y: rect.size.height - 31))
        context.addPath(xAxisPath)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
    }

    private func drawYAxisPath(rect: CGRect) {
        let yAxisPath = CGMutablePath()
        yAxisPath.move(to: CGPoint(x: padding, y: 10))
        yAxisPath.addLine(to: CGPoint(x: padding, y: rect.size.height - 31))
        context.addPath(yAxisPath)
        context.setStrokeColor(UIColor.black.cgColor)
        context.strokePath()
    }

    private func drawYLinePath(rect: CGRect) {
        let yLabelInterval = Int(everest / 5)
        for i in 0...5 {
            let label = axisLabel(title: String(format: "%d", i * yLabelInterval))
            label.frame = CGRect(x: 0, y: floor((rect.size.height - padding) - CGFloat(i) * (axisHeight / 5) - 10), width: 20, height: 20)
            addSubview(label)

            if showLines && i != 0 {
                let line = CGMutablePath()
                line.move(to: CGPoint(x: padding + 1, y: floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5))))
                line.addLine(to: CGPoint(x: axisWidth, y: floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5))))
                context.addPath(line)
                context.setLineWidth(1)
                context.setStrokeColor(linesColor.cgColor)
                context.strokePath()
            }
        }
    }

    func drawAllLinePath() {
        let pointPath = CGMutablePath()
        let firstPoint = data[0][data[0].keys.first!]
        let initialY: CGFloat = ceil((CGFloat(firstPoint!) * (axisHeight / everest))) - 10
        let initialX: CGFloat = padding + xMargin
        pointPath.move(to: CGPoint(x: initialX, y: graphHeight - initialY))

        // 始点以降の処理
        for eachData in data {
            // x軸のラベル、頂点の丸、を描画
            plotPoint(point: [eachData.keys.first!: eachData.values.first!], path: pointPath)
        }
        // 線を結ぶ頂点を登録
        context.addPath(pointPath)
        // 線の幅
        context.setLineWidth(2)
        // 線の色
        context.setStrokeColor(UIColor.black.cgColor)
        // 線を引く
        context.strokePath()
    }

    private func addSubViewOriginLabel() {
        let originLabel = UILabel()
        originLabel.text = originLabelText
        originLabel.textAlignment = .center
        originLabel.font = labelFont
        originLabel.textColor = UIColor.black
        originLabel.backgroundColor = backgroundColor
        originLabel.frame = CGRect(x: -2, y: graphHeight + 20, width: 40, height: 20)
        addSubview(originLabel)
    }

    // Plot a point on the graph
    private func plotPoint(point: [String: Int], path: CGMutablePath) {

        // work out the distance to draw the remaining points at
        let interval = Int(graphWidth - xMargin * 2) / (data.count - 1)

        let pointValue = point[point.keys.first!]

        // Calculate X and Y positions
        let yposition: CGFloat = ceil((CGFloat(pointValue!) * (axisHeight / everest))) - 10

        var index = 0
        for (ind, value) in data.enumerated() {
            if point.keys.first! == value.keys.first! && point.values.first! == value.values.first! {
                index = ind
            }
        }
        let xposition = CGFloat(interval * index) + padding + xMargin

        // X軸の各値のラベルを表示
        strokeXAxisLabel(point: point, position: xposition)
        // 現在日付以前のデータのみを表示
        switch graphType {
        case .week:
            if isThereSameDayOfWeek {
                break
            } else {
                if df.getDayOfWeekByStr(date: Date()) == point.keys.first! {
                    isThereSameDayOfWeek = true
                }
                // 線を登録
                path.addLine(to: CGPoint(x: xposition, y: graphHeight - yposition))
                // 頂点の円を描画
                strokePointMarker(xPosition: xposition, yPosition: yposition)
            }
        case .month:
            // 日を比較
            if Int(df.getDayOfMonthByStr(date: Date()))! >= Int(point.keys.first!)! {
                path.addLine(to: CGPoint(x: xposition, y: graphHeight - yposition))
                strokePointMarker(xPosition: xposition, yPosition: yposition)
            }
        case .year:
            // 月を比較
            if Int(df.getMonthOfYearByStr(date: Date()))! >= Int(point.keys.first!)! {
                path.addLine(to: CGPoint(x: xposition, y: graphHeight - yposition))
                strokePointMarker(xPosition: xposition, yPosition: yposition)
            }
        case .none:
            break
        }

    }

    // X軸のラベルを描画
    private func strokeXAxisLabel(point: [String: Int], position: CGFloat) {
        let xLabel = axisLabel(title: point.keys.first!)
        xLabel.frame = CGRect(x: position - 18, y: graphHeight + 20, width: 36, height: 20)
        xLabel.textAlignment = .center
        // 今月のグラフを表示してる場合
        // 今週:7個、今年:12個
        if data.count > 12 {
            guard let pointByNum = Int(point.keys.first!) else {
                return
            }
            if pointByNum % 2 == 0 {
                addSubview(xLabel)
            }
        } else {
            addSubview(xLabel)
        }
    }

    // 円を描画
    private func strokePointMarker(xPosition: CGFloat, yPosition: CGFloat) {
        if showPoints {
            // Add a marker for this value
            let pointMarker = valueMarker()
            pointMarker.frame = CGRect(x: xPosition - 8, y: CGFloat(ceil(graphHeight - yPosition) - 8), width: 16, height: 16)
            layer.addSublayer(pointMarker)
        }
    }

    // X軸の値を表示するためのLabel
    private func axisLabel(title: String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.text = title as String
        label.font = labelFont
        label.textColor = UIColor.black
        label.backgroundColor = backgroundColor
        label.textAlignment = NSTextAlignment.right

        return label
    }

    // 頂点の円を描くためのCALayer
    func valueMarker() -> CALayer {
        let pointMarker = CALayer()
        pointMarker.backgroundColor = backgroundColor?.cgColor
        pointMarker.cornerRadius = 8
        pointMarker.masksToBounds = true

        let markerInner = CALayer()
        markerInner.frame = CGRect(x: 3, y: 3, width: 10, height: 10)
        markerInner.cornerRadius = 5
        markerInner.masksToBounds = true
        markerInner.backgroundColor = UIColor.black.cgColor

        pointMarker.addSublayer(markerInner)

        return pointMarker
    }

}
