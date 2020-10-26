//
//  MainViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/10/10.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet private weak var todoListStackView: UIStackView!
    private var todoListResults: Results<ToDoModel>!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realmにデータが保存されてるかを確認
        let realm = try! Realm()
        if realm.objects(ToDoModel.self).isEmpty == false {
            todoListStackView.layer.borderWidth = 1
            todoListResults = realm.objects(ToDoModel.self)
            setTodoList(numberOfItems: todoListResults[0].todoList.count)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListStackView.layer.cornerRadius = 5
        todoListStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setTapGestureInTodoListView(_:))))
    }

    // タスクリストのレイアウトを調整
    private func setTodoList(numberOfItems: Int) {
        // todoListStackViewの子要素を全て削除
        let subviews = todoListStackView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        // 子要素View(>Label)を生成し、AutoLayoutを設定し、todoListViewに組み込む
        for n in 0..<numberOfItems {
            let view = UIView()
            view.heightAnchor.constraint(equalToConstant: 59).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = todoListResults[0].todoList[n]
            label.textAlignment = .center
            view.addSubview(label)

            // AutoLayout
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
            label.translatesAutoresizingMaskIntoConstraints = false
            view.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
            view.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true

            todoListStackView.addArrangedSubview(view)
        }
    }

    @objc
    private func displayPopup() {
        // Notificationを削除
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private func setTapGestureInTodoListView(_ sender: UITapGestureRecognizer) {
        // タスクリストがあれば追加画面へ、無ければ編集画面へ
        if todoListResults != nil {
            // Notificationを発火
            NotificationCenter.default.post(name: Notification.Name(rawValue: "notification"), object: "通知で〜す")
            performSegue(withIdentifier: IdentifierType.segueToEditFromMain, sender: todoListResults)
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
            todoListEditVC.results = results
        }
    }

    @IBAction func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        let todoListAddVC = unwindSegue.source as! ToDoListAddViewController
        // Notificationを登録
        NotificationCenter.default.addObserver(self, selector: #selector(displayPopup), name: Notification.Name(rawValue: "notification"), object: nil)
    }
}
