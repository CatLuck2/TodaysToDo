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
    // セルのタイプ
    let itemList = BehaviorRelay<[ToDoListModel]>(value: [])
    var itemListObservable: Observable<[ToDoListModel]> {
        itemList.asObservable()
    }

    func isThereEmptyTitle() -> Bool {
        for item in itemList.value {
            if let title = item.title,
               item.cellType == .input,
               title.isEmpty {
                return true
            }
        }
        return false
    }

    func setupItemList(limitedNumberOfCell: Int) {
        if getIsEmptyOfDataInRealm() || getIsEmptyOfTodoList() {
            var initialItemList = [ToDoListModel(cellType: .input, title: "")]
            if limitedNumberOfCell != 1 {
                initialItemList.append(ToDoListModel(cellType: .add, title: nil))
            }
            itemList.accept(initialItemList)
        } else {
            var initialItemList = [ToDoListModel]()
            for _ in 0..<getCountOfTodoList() {
                // todoListの要素数だけ、Inputを生成
                initialItemList.append(ToDoListModel(cellType: .input, title: ""))
            }
            let todoList = getTodoList()
            for i in 0..<getCountOfTodoList() {
                initialItemList[i].title = todoList[i]
            }
            // 最後にAddを追加
            if getCountOfTodoList() < limitedNumberOfCell {
                initialItemList.append(ToDoListModel(cellType: .add, title: nil))
            }
            itemList.accept(initialItemList)
        }
    }

    func getOverlapOfKeyboard(notification: Notification, frame: CGRect) -> CGFloat {
        // キーボードの情報を取得
        guard let keyboardInfo = notification.userInfo else {
            return 0
        }
        // キーボードのFrameを取得
        let keyboardFrame = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // textFieldの上端のy
        let screenHeight = UIScreen.main.bounds.height
        let textFieldTopY = screenHeight - keyboardFrame.size.height
        // textFieldの下端のy
        let originY = frame.origin.y
        let height = frame.height
        let textFieldBottomY = originY + height
//        print(textFieldTopY, textFieldBottomY)
        // textFieldとキーボードが重なる領域
        return textFieldBottomY - textFieldTopY
    }

    // Realmとのやりとり
    private let todoLogicModel: ToDoLogicModel
    var testToDoModelObservable: Observable<[TestToDoModel]> {
        todoLogicModel.todoItemsObservable
    }

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    func add(todoList: [String]) {
        todoLogicModel.addTodoList(todoList: todoList)
    }

    func updateTodoList(todoElement: [String]) {
        todoLogicModel.updateTodoList(todoElement: todoElement)
    }

    func delete(row: Int) {
        todoLogicModel.deleteElementInTodoList(row: row)
    }

    func getCountOfTodoList() -> Int {
        todoLogicModel.getCount()
    }

    func getTodoList() -> [String] {
        todoLogicModel.getTodoList()
    }

    func getIsEmptyOfDataInRealm() -> Bool {
        todoLogicModel.isEmptyOfDataInRealm
    }

    func getIsEmptyOfTodoList() -> Bool {
        todoLogicModel.isEmptyOfTodoList
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
