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

    private let realm = try! Realm()
    var results: Results<ToDoModel>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results = realm.objects(ToDoModel.self)
        setTodoList(numberOfItems: results[0].toDoList.count)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListView.layer.borderWidth = 1
        todoListView.layer.cornerRadius = 5
        todoListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
    }

    private func setTodoList(numberOfItems: Int) {
        for n in 0..<numberOfItems {
            let myView = UIView()
            let label = UILabel()
            myView.heightAnchor.constraint(equalToConstant: 59).isActive = true
            myView.translatesAutoresizingMaskIntoConstraints = false

            label.text = results[0].toDoList[n]
            label.textAlignment = .center
            myView.addSubview(label)

            label.topAnchor.constraint(equalTo: myView.topAnchor, constant: 8).isActive = true
            myView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
            label.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
            myView.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false

            todoListView.addArrangedSubview(myView)
        }
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
