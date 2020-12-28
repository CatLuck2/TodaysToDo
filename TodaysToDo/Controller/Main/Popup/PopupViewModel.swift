//
//  PopupViewModel.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/12/25.
//

import Foundation
import UIKit

class PopupViewModel {
    private let todoLogicModel: ToDoLogicModel
    var tableViewController = TableViewController()

    init(todoLogicModel: ToDoLogicModel) {
        self.todoLogicModel = todoLogicModel
    }

    @objc
    func saveTaskListData(date: Date, numOfTask: Int, numOfCompletedTask: Int) {
        todoLogicModel.saveTaskListData(date: date, numOfTask: numOfTask, numOfCompletedTask: numOfCompletedTask)
    }

    func getPerByDevice(viewHeight: CGFloat) -> CGFloat {
        var per: CGFloat = 0
        switch viewHeight {
        case 400.0..<500.0:
            per = 100
        case 500.0..<600.0:
            per = 120
        case 600.0..<700.0:
            per = 140
        case 700.0..<800.0:
            per = 160
        case 800.0..<850.0:
            per = 180
        case 850.0..<899.0:
            per = 200
        default:
            break
        }
        return per / 100
    }

    func setConstraintForStackView(stackView: UIStackView, parentView: UIView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20.0).isActive = true
        stackView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 20.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -20.0).isActive = true
    }
}
