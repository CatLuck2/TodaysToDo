//
//  ToDoItemCellForEdit.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/22.
//

import UIKit

class ToDoItemCellForEdit: UITableViewCell, UITextFieldDelegate {

    // ToDoListEditVCから参照されるため、privateはなし
    @IBOutlet private(set) weak var todoItemTextField: UITextField!
    var textFieldValueSender: ((Any) -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        todoItemTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
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
