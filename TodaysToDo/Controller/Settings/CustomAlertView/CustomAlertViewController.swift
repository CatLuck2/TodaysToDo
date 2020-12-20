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
    var selectedEndTime: (Int, Int)!
    var selectedNumber: Int!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickerTitleArray = []
        switch pickerMode {
        case .endtimeOfTask:
            titleLabel.text = "タスク終了時刻"
            messageLabel.text = "終了通知の時刻を入力してください"
            pickerTitleArray.append(Array(0...23))
            pickerTitleArray.append(Array(0...59))
            // pickerViewで初期位置
            pickerView.selectRow(selectedEndTime.0, inComponent: 0, animated: false)
            pickerView.selectRow(selectedEndTime.1, inComponent: 1, animated: false)
        case .numberOfTask:
            titleLabel.text = "タスク設定数"
            messageLabel.text = "最大設定数を入力してください"
            pickerTitleArray.append(Array(1...5))
            pickerView.selectRow(selectedNumber - 1, inComponent: 0, animated: false)
        case .none:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func setInitializeFromAnotherVC(pickerMode: PickerMode, selectedEndTime: (Int, Int), selectedNumber: Int) {
        self.pickerMode = pickerMode
        self.selectedEndTime = selectedEndTime
        self.selectedNumber = selectedNumber
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
        switch pickerMode {
        case .endtimeOfTask:
            let row1 = pickerView.selectedRow(inComponent: 0)
            let row2 = pickerView.selectedRow(inComponent: 1)
            selectedEndTime = (pickerTitleArray[0][row1], pickerTitleArray[1][row2])
        case .numberOfTask:
            let row1 = pickerView.selectedRow(inComponent: 0)
            selectedNumber = pickerTitleArray[0][row1]
        case .none:
            break
        }
    }

    @IBAction private func okButton(_ sender: UIButton) {
        performSegue(withIdentifier: R.segue.customAlertViewController.unwindToSettingsVCFromCustomAlert, sender: nil)
    }

    @IBAction private func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
