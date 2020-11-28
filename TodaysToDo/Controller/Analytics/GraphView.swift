//
//  GraphView.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/31.
//

import UIKit

class GraphView: UIView {

    private var lineWidth: CGFloat = 3.0 //グラフ線の太さ
    private var lineColor = UIColor(red: 0.088, green: 0.501, blue: 0.979, alpha: 1) //グラフ線の色

    private var memoriMargin: CGFloat = 0 //横目盛の感覚
    private var graphHeight: CGFloat = 250 //グラフの高さ
    private var graphPoints: [String] = [] //グラフの横目盛り
    private var graphDatas: [CGFloat] = [] //グラフの値

    // グラフ関連の変数を初期化
    private func initVariables() {
        graphPoints = []
        graphDatas = []
    }

    // 今週用のグラフを描画
    func drawWeekLineGraph(screenWidth: CGFloat) {
        initVariables()
        graphPoints = ["日", "月", "火", "水", "木", "金", "土"]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        for day1 in Date().allDaysOfWeek {
            var isContainedSameDay = false
            for day2 in RealmResults.sharedInstance[0].weekList {
                if calendar.isDate(day1, inSameDayAs: day2.date!) {
                    graphDatas.append(CGFloat(day2.numberOfCompletedTask))
                    isContainedSameDay = true
                }
            }
            if isContainedSameDay == false {
                graphDatas.append(0)
            }
        }
        // 画面幅 = 余白(10) + グラフの幅((目盛り数-1) x 目盛り幅) + 余白(10)
        memoriMargin = (screenWidth - 20) / CGFloat((graphPoints.count - 1))
        graphFrame()
        memoriGraphDraw()
    }

    // 今月用のグラフを描画
    func drawMonthLineGraph(screenWidth: CGFloat) {
        initVariables()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        for day1 in Date().allDaysOfMonth {
            var isContainedSameDay = false
            graphPoints.append("\(day1.dayFromMonthOfDataType)")
            for day2 in RealmResults.sharedInstance[0].monthList {
                if calendar.isDate(day1, inSameDayAs: day2.date!) {
                    graphDatas.append(CGFloat(day2.numberOfCompletedTask))
                    isContainedSameDay = true
                }
            }
            if isContainedSameDay == false {
                graphDatas.append(0)
            }
        }
        memoriMargin = (screenWidth - 20) / CGFloat((graphPoints.count - 1))
        graphFrame()
        memoriGraphDraw()
    }

    // 今年用のグラフを描画
    func drawYearLineGraph(screenWidth: CGFloat) {
        initVariables()
        graphPoints = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        for month in RealmResults.sharedInstance[0].yearList {
            graphDatas.append(CGFloat(month.total))
        }
        memoriMargin = (screenWidth - 20) / CGFloat((graphPoints.count - 1))
        graphFrame()
        memoriGraphDraw()
    }

    //グラフを描画するviewの大きさ
    private func graphFrame() {
        self.backgroundColor = UIColor(red: 0.972, green: 0.973, blue: 0.972, alpha: 1)
        self.frame = CGRect(x: 10, y: 0, width: checkWidth(), height: checkHeight())
    }

    //横目盛・グラフを描画する
    private func memoriGraphDraw() {

        var count: CGFloat = 0
        for memori in graphPoints {
            //ラベル作成〜設定
            let label = UILabel()
            label.text = String(memori)
            label.font = UIFont.systemFont(ofSize: 9)

            //ラベルの位置情報
            //ラベルのサイズを取得
            let frame = CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude)
            let rect = label.sizeThatFits(frame)

            //ラベルの位置
            var lebelX = (count * memoriMargin) - rect.width / 2
            //最初のラベル
            if Int(count) == 0 {
                lebelX = (count * memoriMargin)
            }
            //最後のラベル
            if Int(count + 1) == graphPoints.count {
                lebelX = (count * memoriMargin) - rect.width
            }

            //ラベルを描画
            label.frame = CGRect(x: lebelX, y: graphHeight, width: rect.width, height: rect.height)
            self.addSubview(label)
            // 月のグラフで横目盛りを減らす
            if graphPoints.count > 12 {
                if Int(memori)! % 7 != 0 {
                    label.isHidden = true
                }
            }

            count += 1
        }
    }

    // graphDatasの最大値-最低値
    var yAxisMax: CGFloat {
        (graphDatas.max() ?? 0) - (graphDatas.min() ?? 0)
    }

    //グラフ横幅を算出
    func checkWidth() -> CGFloat {
        CGFloat(graphPoints.count - 1) * memoriMargin
    }

    //グラフ縦幅を算出
    func checkHeight() -> CGFloat {
        graphHeight
    }

    //グラフの線を描画
    override func draw(_ rect: CGRect) {
        var count: CGFloat = 0
        let linePath = UIBezierPath() //線

        linePath.lineWidth = lineWidth //線の幅
        lineColor.setStroke() //UIBezierPathに色を適用？

        //datapoint:各点の値
        //move -> addLine -> addLine -> ... -> linePath.stroke()
        for datapoint in graphDatas {
            //count+1がgraphDatas.countを超えるまでループ
            if Int(count + 1) < graphDatas.count {

                //終点(2回目以降のループ)
                var nextY: CGFloat = 0
                //(値 / （最大値ー最小値）* (グラフの高さ))
                nextY = graphDatas[Int(count + 1)]/yAxisMax * (graphHeight)
                //グラフの高さー nextY
                nextY = graphHeight - nextY
                if (graphDatas.min() ?? 0) < 0 {
                    nextY = (graphDatas[Int(count + 1)] - (graphDatas.min() ?? 0)) / yAxisMax * (graphHeight)
                    nextY = graphHeight - nextY
                }

                //最初の開始地点を指定（1回目のループ）
                //count==0の時、count>0はnowYを採用？
                //始点(値 / （最大値ー最小値）* (グラフの高さー点の半径))
                var nowY: CGFloat = datapoint / yAxisMax * (graphHeight)
                nowY = graphHeight - nowY
                //graphDatasの最小値がマイナスの場合
                if (graphDatas.min() ?? 0) < 0 {
                    nowY = (datapoint - (graphDatas.min() ?? 0)) / yAxisMax * (graphHeight)
                    nowY = graphHeight - nowY
                }
                //最初のループ時にのみ発動
                if Int(count) == 0 {
                    //yが増加すると、開始地点が低くなる
                    linePath.move(to: CGPoint(x: 0, y: nowY))
                }

                //描画ポイントを指定
                //原点からx座標を計算
                linePath.addLine(to: CGPoint(x: (count + 1) * memoriMargin, y: nextY))
            }
            count += 1
        }
        //折れ線グラフを描画
        linePath.stroke()
    }

}
