//
//  ToDoListModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum CellItemType {
    case add
    case input
}

class ToDoListModel {
    var cellType: CellItemType
    var title: String?

    init(cellType: CellItemType, title: String?) {
        self.cellType = cellType
        self.title = title
    }
}
