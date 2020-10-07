## プロジェクト概要
- 名前：TTD~TodaysToDo
- コンセプト：今日だけのタスクで目の前に集中しよう
- 転職用のポートフォリオなので、使える技術は全て使う

## 機能一覧
- タスクのCRUD
- ユーザーが設定した時刻に全タスクを削除/新規タスク作成

## 使用したい技術
- RxSwift
- アーキテクチャ(MVC,MVPなど)
- GitHubActions
- XCTest,XCUITest

## スケジュール
完成：12/31まで

## Git開発フロー

１、developからfeatureを分岐し、新機能を開発
２、エラーや問題が起きたら、devleopからbugを分岐し、解決
３、リリース可能状態になったら、developをmasterにマージ

プルリクをマージしたら？
→マージ元のブランチを削除
→developは削除しない

命名規則
→feature/issue_番号,bug/issue_番号

「各ブランチの概要」
- master:リリース
- develop:開発
- feature:機能拡張
- bug:不具合、バグ、修正

## 使用ツール
- Xcode
- GitHubDesktop
- RealmStudio
- SwiftLint
- SwiftFormat
