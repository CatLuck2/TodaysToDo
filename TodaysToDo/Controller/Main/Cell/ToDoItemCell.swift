//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

protocol customCellDelagete: AnyObject {
    func textFieldDidSelected(_ textField: UITextField)
}

class ToDoItemCell: UITableViewCell, UITextFieldDelegate, UITextDropDelegate {

    // ToDoListAddVCから参照されるため、privateはなし-> Void)!
    @IBOutlet weak var todoItemTextField: UITextField!
    var textFieldValueSender: ((Any) -> Void)!
    private var nowFrame: CGRect!
    weak var customCellDelegate: customCellDelagete?

    override func awakeFromNib() {
        super.awakeFromNib()
        todoItemTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        todoItemTextField.addTarget(self, action: #selector(textFieldChange(_:)), for: .editingDidBegin)
        todoItemTextField.delegate = self
        todoItemTextField.textDropDelegate = self
    }

    // textFieldをドラッグ時、中のテキストをドロップしないようにする
    func textDroppableView(_ textDroppableView: UIView & UITextDroppable, proposalForDrop drop: UITextDropRequest) -> UITextDropProposal {
        UITextDropProposal(operation: .cancel)
    }

    func resetTextField() {
        todoItemTextField.text = ""
    }

    func setTodoItemCell(name: String) {
        todoItemTextField.text = name
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textFieldChange(_ textField: UITextField) {
        customCellDelegate!.textFieldDidSelected(textField)
    }

    @objc
    private func textFieldDidChange(sender: UITextField) {
        // textFieldに入力するたびにToDoListAddVCへ送られる
        self.textFieldValueSender(sender.text ?? "")
    }
}
