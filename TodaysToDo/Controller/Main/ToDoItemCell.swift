//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoItemCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var todoItemLabel: UILabel!
    @IBOutlet weak var todoItemTextField: UITextField!

    var textFieldValueSender: ((Any) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        todoItemTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTodoItemCell(name: String) {
        todoItemTextField.text = name
    }

    func resetTextField() {
        todoItemTextField.text = ""
    }

    @objc func textFieldDidChange(sender: UITextField) {
        self.textFieldValueSender!(sender.text!)
    }

}
