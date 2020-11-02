//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoItemCellForAdd: UITableViewCell, UITextFieldDelegate {

    // ToDoListAddVCから参照されるため、privateはなし
    @IBOutlet private(set) weak var todoItemTextField: UITextField!
    var textFieldValueSender: ((Any) -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        todoItemTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
    }

    func resetTextField() {
        todoItemTextField.text = ""
    }

    @objc
    private func textFieldDidChange(sender: UITextField) {
        // textFieldに入力するたびにToDoListAddVCへ送られる
        self.textFieldValueSender(sender.text ?? "")
    }

}
