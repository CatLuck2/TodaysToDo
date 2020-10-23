//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoItemCellForAdd: UITableViewCell, UITextFieldDelegate {

    @IBOutlet private weak var todoItemLabel: UILabel!
    @IBOutlet weak var todoItemTextField: UITextField!

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
        self.textFieldValueSender(sender.text ?? "")
    }

}
