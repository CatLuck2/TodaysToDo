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
    private(set) var selectedEndtime: (Int, Int)!
    private(set) var selectedNumber: Int!

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
        case .numberOfTask:
            titleLabel.text = "タスク設定数"
            messageLabel.text = "最大設定数を入力してください"
            pickerTitleArray.append(Array(1...5))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
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
