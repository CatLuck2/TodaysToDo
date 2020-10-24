//
//  IdentifierType.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/16.
//

import UIKit

enum IdentifierType {
    // inputのセルID
    static let cellForAddID = "toDoItemCellForAdd"
    static let cellForEditID = "toDoItemCellForEdit"
    // addのセルID
    static let newItemcCellID = "newAddItemCell"
    // segueID
    static let segueToEditFromMain = "toEdit"
    static let segueToAddFromMain = "toAdd"
    // Realmのモデルで使用するID
    static let realmModelID = "toDoList"
}
