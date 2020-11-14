//
//  HelpDetailViewController.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/10.
//

enum HelpType {
    case whatIsTodaysTodo
    case tutorialCreateTask
    case tutorialEditAndDeleteTask
    case whatIsEndTime
    case tutorialEndTime
    case whatIsPriority
}

import UIKit
import AVKit

class HelpDetailViewController: UIViewController {

    @IBOutlet private weak var helpDetailTextView: UITextView!
    @IBOutlet private weak var helpDetailPlayerView: PlayerView!

    var navigationTitle: String!
    var helpTypeValue: HelpType!
    var player = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard self.navigationController != nil else {
            return
        }
        self.navigationItem.title = navigationTitle

        switch helpTypeValue {
        case .whatIsTodaysTodo:
            setTextView(text: "今日だけのタスクを管理できるアプリです。\n\n少数のタスクだけを作成により、今日やるべきことに集中でき、効率的なタスク消化を生み出します。\n\nただし、複数個（6個）のタスクを作成できず、ジャンルやグループなどのタスクを細かく管理する機能がありません。\n\n")
        case .tutorialCreateTask:
            setPlayerView(fileName: "タスク作成", fileExtension: "mp4")
        case .tutorialEditAndDeleteTask:
            setPlayerView(fileName: "タスク編集と削除", fileExtension: "mp4")
        case .whatIsEndTime:
            setTextView(text: "タスク終了を通知するアラートの表示時刻です。\n\n設定した時刻に自動でアラート画面が表示され、アラート画面で作成したタスクを確認チェックできます。\n\nチェックした場合、ユーザーのタスク達成率のデータに反映されます。")
        case .tutorialEndTime:
            setPlayerView(fileName: "アラート", fileExtension: "mp4")
        case .whatIsPriority:
            setTextView(text: "タスクに優先機能を付与できる機能です。\n\n例えば、３つのタスクで優先順位を付与した場合、1番目のタスクがチェックされない限り、2,3番目のタスクをチェックできません。\n\n注意点として、タスクを作成した後に本機能をON/OFFすることはできません。")
        case .none:
            break
        }
    }

    private func setTextView(text: String) {
        helpDetailTextView.text = text
        helpDetailTextView.isHidden = false
    }

    private func setPlayerView(fileName: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Url is nil")
            return
        }

        helpDetailPlayerView.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(didEndPlayerView), name: .AVPlayerItemDidPlayToEndTime, object: nil)

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        helpDetailPlayerView.player = player
        player.play()
    }

    @objc
    private func didEndPlayerView() {
        player.seek(to: CMTime.zero)
        player.play()
    }

}