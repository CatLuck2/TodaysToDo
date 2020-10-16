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
    var results: Results<ToDoModel>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results = realm.objects(ToDoModel.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
        parentViewOfStack.layer.borderWidth = 0.5
        parentViewOfStack.layer.cornerRadius = 15
    }

    @objc private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        let dictionary: [String: Any] = [IdentifierType.realmModelID: ["test", "test"]]
        let toDoModel = ToDoModel(value: dictionary)
        // Realmに保存
        try! realm.write {
            realm.add(toDoModel, update: .modified)
        }
        performSegue(withIdentifier: IdentifierType.segueToEditFromMain, sender: results)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierType.segueToEditFromMain {
            guard let nvc = segue.destination as? UINavigationController else { return }
            guard let todoListEditVC = nvc.viewControllers[0] as? ToDoListEditViewController else { return }
            guard let results = sender as? Results<ToDoModel> else { return }
            todoListEditVC.todoList = results
        }
    }
}
