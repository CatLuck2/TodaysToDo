//
//  ToDoItemCellForEdit.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/22.
//

import UIKit

class ToDoItemCellForEdit: UITableViewCell {

    @IBOutlet weak var todoItemTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTodoItemCell(name: String) {
        todoItemTextField.text = name
    }

}
