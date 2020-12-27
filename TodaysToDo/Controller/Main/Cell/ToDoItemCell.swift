//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoItemCell: UITableViewCell, UITextFieldDelegate, UITextDropDelegate {

    // ToDoListAddVCから参照されるため、privateはなし-> Void)!
    @IBOutlet weak var todoItemTextField: UITextField!
    private var nowFrame: CGRect!

    override func awakeFromNib() {
        super.awakeFromNib()
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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
