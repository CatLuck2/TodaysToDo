//
//  ToDoItemCellForEdit.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/22.
//

import UIKit

class ToDoItemCellForEdit: UITableViewCell {

    // ToDoListEditVCから参照されるため、privateはなし
    @IBOutlet weak var todoItemTextField: UITextField!

    func setTodoItemCell(name: String) {
        todoItemTextField.text = name
    }

}
