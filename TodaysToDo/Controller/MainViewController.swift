//
//  MainViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet private weak var todoListView: UIStackView!
    @IBOutlet private weak var parentViewOfStack: UIView!

    private let realm = try! Realm()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let results = realm.objects(ToDoModel.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
        parentViewOfStack.layer.borderWidth = 0.5
        parentViewOfStack.layer.cornerRadius = 15
    }

    @objc private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        let dictionary: [String: Any] = ["toDoList": ["test", "test"]]
        let toDoModel = ToDoModel(value: dictionary)
        // Realmに保存
        try! realm.write {
            realm.create(ToDoModel.self, value: toDoModel, update: .modified)
        }
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
}
