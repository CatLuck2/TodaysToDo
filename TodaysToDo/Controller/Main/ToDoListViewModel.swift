//
//  ToDoListViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/24.
//

import Foundation
import RxSwift
import RxCocoa

class ToDoListViewModel {
    let itemList = BehaviorRelay<[ToDoListModel]>(value: [])

    var itemListObservable: Observable<[ToDoListModel]> {
        itemList.asObservable()
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(model: Element.Element) {
        var array = self.value
        array.append(model)
        self.accept(array)
    }

    func update(model: Element.Element, index: Element.Index) {
        var array = self.value
        array.remove(at: index)
        array.insert(model, at: index)
        self.accept(array)
    }

    func insert(model: Element.Element, index: Element.Index) {
        var array = self.value
        array.insert(model, at: index)
        self.accept(array)
    }

    func remove(index: Element.Index) {
        var array = self.value
        array.remove(at: index)
        self.accept(array)
    }
}
