//
//  IdentifierType.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/16.
//

enum IdentifierType {
    // inputのセルID
    static let cellForAddID = "todoItemCellForAdd"
    static let cellForEditID = "todoItemCellForEdit"
    static let cellForSettingsID = "cellForSettingsID"
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
