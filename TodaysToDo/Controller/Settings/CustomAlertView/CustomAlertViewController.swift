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

class CustomAlertViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var pickerView: UIPickerView!

    private var pickerTitleArray: [String] = []
    var pickerMode: PickerMode!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard pickerMode != nil else {
            return
        }
        switch pickerMode! {
        case .endtimeOfTask:
            break
        case .numberOfTask:
            break
        }
    }

    @IBAction private func okButton(_ sender: UIButton) {
    }

    @IBAction private func cancelButton(_ sender: UIButton) {
    }

}
