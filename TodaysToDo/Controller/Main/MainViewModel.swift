//
//  MainViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation
import UIKit

class MainViewModel {
    private let todoLogicModel: ToDoLogicModel

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    // Realmデータの操作
    func read() {
        todoLogicModel.readTestToDoModel()
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

    // UI関連
    func getUIsForAdd() -> UIView {
        let view = UIView()
        if #available(iOS 14, *) {} else {
            view.backgroundColor = .lightGray
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 5
        }

        let label = UILabel()
        label.text = "タスクを追加"
        label.textAlignment = .center
        view.addSubview(label)

        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
        view.heightAnchor.constraint(equalToConstant: 59).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    func getUIsForEditTask(numberOfItems: Int, numberOfItem: Int) -> UIView {
        // UserDefaultから設定項目のデータを取得
        let sv = SettingsValue()
        let settingsValueOfTask = sv.readSettingsValue()
        // RealmのtodoList
        let todoList = todoLogicModel.getTodoList()
        // 子要素View(>Label)を生成し、AutoLayoutを設定し、todoListViewに組み込む
        let view = UIView()
        // 優先機能はON?
        if settingsValueOfTask.priorityOfTask {
            // viewの背景色にヒートマップ的な色を指定
            let rgbPercentage: CGFloat = ((CGFloat(numberOfItem) / CGFloat(numberOfItems)))
            view.backgroundColor = UIColor(red: 1.0, green: rgbPercentage, blue: 0.0, alpha: 1)
            view.layer.cornerRadius = 5
        } else {
            if #available(iOS 14, *) {} else {
                view.backgroundColor = .lightGray
            }
        }
        if #available(iOS 14, *) {} else {
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 5
        }
        view.heightAnchor.constraint(equalToConstant: 59).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = todoList[numberOfItem]
        label.textAlignment = .center
        view.addSubview(label)

        // AutoLayout
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true

        return view
    }

    func getUIsForEndTask() -> (UIImageView, UITextView) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "タスク終了画像")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0 / 1.2).isActive = true

        let textView = UITextView()
        textView.textAlignment = .center
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        textView.text = "本日のタスクは終了しました。"
        textView.isScrollEnabled = false

        return (imageView, textView)
    }
}
