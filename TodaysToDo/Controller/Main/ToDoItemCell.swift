//
//  ToDoItemCell.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/15.
//

import UIKit

class ToDoItemCell: UITableViewCell {

    @IBOutlet weak var todoItemLabel: UILabel!
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
