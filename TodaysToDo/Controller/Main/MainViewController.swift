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
    private var results: Results<ToDoModel>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Realmにデータが保存されてるかを確認
        if realm.objects(ToDoModel.self).isEmpty == false {
            todoListView.layer.borderWidth = 1
            results = realm.objects(ToDoModel.self)
            setTodoList(numberOfItems: results[0].toDoList.count)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListView.layer.cornerRadius = 5
        todoListView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
    }

    // タスクリストのレイアウトを調整
    private func setTodoList(numberOfItems: Int) {
        let subviews = todoListView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        // 子要素View(>Label)を生成し、AutoLayoutを設定し、todoListViewに組み込む
        for n in 0..<numberOfItems {
            let myView = UIView()
            let label = UILabel()
            myView.heightAnchor.constraint(equalToConstant: 59).isActive = true
            myView.translatesAutoresizingMaskIntoConstraints = false

            label.text = results[0].toDoList[n]
            label.textAlignment = .center
            myView.addSubview(label)

            // AutoLayout
            label.topAnchor.constraint(equalTo: myView.topAnchor, constant: 8).isActive = true
            myView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
            label.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 8).isActive = true
            myView.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false

            todoListView.addArrangedSubview(myView)
        }
    }

    @objc
    private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        // タスクリストがあれば追加画面へ、無ければ編集画面へ
        if results != nil {
            performSegue(withIdentifier: IdentifierType.segueToEditFromMain, sender: results)
        } else {
            performSegue(withIdentifier: IdentifierType.segueToAddFromMain, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == IdentifierType.segueToEditFromMain {
            // 安全にアンラップするためにguard-let文を使用
            // クラッシュを避けるため、returnを使用
            guard let nvc = segue.destination as? UINavigationController else {
                return
            }
            guard let todoListEditVC = nvc.viewControllers[0] as? ToDoListEditViewController else {
                return
            }
            guard let results = sender as? Results<ToDoModel> else {
                return
            }
            todoListEditVC.todoList = results
        }
    }
}
