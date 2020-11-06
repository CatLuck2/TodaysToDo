//
//  IdentifierType.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/16.
//

enum IdentifierType {
    // inputのセルID
    static let cellForTodoItemID = "todoItemCell"
    static let cellForSettingsID = "cellForSettingsID"
    // セルID
    static let newItemcCellID = "newAddItemCell"
    static let celllForPopup = "cell"
    // segueID
    static let segueToEditFromMain = "toEdit"
    static let segueToAddFromMain = "toAdd"
    static let unwindSegueFromPopupToMain = "unwindSegueFromPopupToMain"
    static let segueToHelp = "settingHelp"
    static let segueToContact = "settingContact"
    // Realmのモデルで使用するID
    static let realmModelID = "todoList"
}
