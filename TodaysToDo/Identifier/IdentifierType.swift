//
//  IdentifierType.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/16.
//

import UIKit

enum IdentifierType {
    // inputのセルID
    static let cellForAddID = "todoItemCellForAdd"
    static let cellForEditID = "todoItemCellForEdit"
    // セルID
    static let newItemcCellID = "newAddItemCell"
    static let celllForPopup = "cell"
    // segueID
    static let segueToEditFromMain = "toEdit"
    static let segueToAddFromMain = "toAdd"
    static let unwindSegueFromPopupToMain = "unwindSegueFromPopupToMain"
    // Realmのモデルで使用するID
    static let realmModelID = "todoList"
}
