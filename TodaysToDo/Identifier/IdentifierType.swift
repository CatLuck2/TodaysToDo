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
    static let cellForHelp = "cellForHelp"
    static let cellForSettings = "cellForSettings"
    // segueID
    static let segueToEditFromMain = "toEdit"
    static let segueToAddFromMain = "toAdd"
    static let unwindSegueFromPopupToMain = "unwindSegueFromPopupToMain"
    static let segueToHelp = "settingHelp"
    static let segueToContact = "settingContact"
    static let unwindToSettingsVCFromCustomAlert = "unwindToSettingsVCFromCustomAlert"
    static let segueToHelpDetail = "segueToHelpDetail"
    // storyboardID
    static let segueToCustomAlert = "segueToCustomAlert"
    // Realmのモデルで使用するID
    static let realmModelID = "todoList"
    // URL
    static let urlForDeveloperTwitter = "https://mobile.twitter.com/nekokichi1_yos2"
    static let urlForGoogleForm = "https://forms.gle/BsQ5sWS3YvETSDfX8"
}
