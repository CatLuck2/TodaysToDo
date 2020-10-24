//
//  ToDoItemCellForEdit.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/22.
//

import UIKit

class ToDoItemCellForEdit: UITableViewCell {

    @IBOutlet weak var todoItemTextField: UITextField!  // ToDoListEditVCから参照されるため、privateはなし

    func setTodoItemCell(name: String) {
        todoItemTextField.text = name
    }

}
