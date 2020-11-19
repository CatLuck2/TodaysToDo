//
//  CustomAlertViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/07.
//

import UIKit

enum PickerMode {
    case endtimeOfTask
    case numberOfTask
}

class CustomAlertViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var pickerView: UIPickerView!

    private var pickerTitleArray: [[Int]] = []
    var pickerMode: PickerMode!
    var selectedEndtime: (Int, Int)!
    var selectedNumber: Int!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard pickerMode != nil else {
            return
        }
        pickerTitleArray = []
        switch pickerMode! {
        case .endtimeOfTask:
            titleLabel.text = "タスク終了時刻"
            messageLabel.text = "終了通知の時刻を入力してください"
            pickerTitleArray.append(Array(0...23))
            pickerTitleArray.append(Array(0...59))
            // pickerViewで初期位置
            pickerView.selectRow(selectedEndtime.0, inComponent: 0, animated: false)
            pickerView.selectRow(selectedEndtime.1, inComponent: 1, animated: false)
        case .numberOfTask:
            titleLabel.text = "タスク設定数"
            messageLabel.text = "最大設定数を入力してください"
            pickerTitleArray.append(Array(1...5))
            pickerView.selectRow(selectedNumber - 1, inComponent: 0, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func compareNowAndEndTime() -> Int {
        // 現在時刻
        let currentDate = Date()
        // 終了時刻
        var endTimeDate = DateComponents()
        let cal = Calendar.current
        endTimeDate.year = cal.component(.year, from: currentDate)
        endTimeDate.month = cal.component(.month, from: currentDate)
        endTimeDate.day = cal.component(.day, from: currentDate)
        endTimeDate.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
        endTimeDate.hour = selectedEndtime.0
        endTimeDate.minute = selectedEndtime.1

        let diff1 = cal.dateComponents([.minute], from: currentDate, to: cal.date(from: endTimeDate)!)
        return diff1.minute!
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        pickerTitleArray.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let compo = pickerTitleArray[component]
        return compo.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = pickerTitleArray[component][row]
        return String(item)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerMode! {
        case .endtimeOfTask:
            let row1 = pickerView.selectedRow(inComponent: 0)
            let row2 = pickerView.selectedRow(inComponent: 1)
            selectedEndtime = (pickerTitleArray[0][row1], pickerTitleArray[1][row2])
        case .numberOfTask:
            let row1 = pickerView.selectedRow(inComponent: 0)
            selectedNumber = pickerTitleArray[0][row1]
        }
    }

    @IBAction private func okButton(_ sender: UIButton) {
        performSegue(withIdentifier: IdentifierType.unwindToSettingsVCFromCustomAlert, sender: nil)
    }

    @IBAction private func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
