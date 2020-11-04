//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoItemCell: UITableViewCell, UITextFieldDelegate {

    // ToDoListAddVCから参照されるため、privateはなし-> Void)!
    @IBOutlet weak var todoItemTextField: UITextField!
    var textFieldValueSender: ((Any) -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        todoItemTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
    }

    func resetTextField() {
        todoItemTextField.text = ""
    }

    func setTodoItemCell(name: String) {
        todoItemTextField.text = name
    }

    @objc
    private func textFieldDidChange(sender: UITextField) {
        // textFieldに入力するたびにToDoListAddVCへ送られる
        self.textFieldValueSender(sender.text ?? "")
    }

}