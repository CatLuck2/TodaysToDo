//
//  ToDoListViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ToDoListViewModel {
    let itemList = BehaviorRelay<[ToDoListModel]>(value: [])

    var itemListObservable: Observable<[ToDoListModel]> {
        itemList.asObservable()
    }
}
