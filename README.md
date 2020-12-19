## プロジェクト概要
- 名前：TTD~TodaysToDo
- コンセプト：今日だけのタスクで目の前に集中しよう
- 転職用のポートフォリオなので、使える技術は全て使う

## 機能一覧
https://drive.google.com/file/d/1lXRyTEmOhXcmnV8cMVx_a8y_vvwR48fe/view?usp=sharing

## 画面モック
https://drive.google.com/drive/folders/1ZiOScdaVKNbnzg-GxjZqJb76NDpCMygK?usp=sharing

## 使用したい技術
- RxSwift
- アーキテクチャ(MVC,MVPなど)
- GitHubActions
- XCTest,XCUITest

## 開発段階

### フェーズ1:最低限の仕様を搭載したベータ版
- 最優先で早急に達成させる
- 本アプリのメイン機能のみを実装

### フェーズ2:欲しい仕様を搭載した完成版
- じっくり慎重に行う
- 本アプリに欲しい機能を実装

### フェーズ3:改善を加えた修正版
- 時間的余裕があった場合にのみ
- アーキテクチャ
- 総合的なリファクタリング
- RxSwiftを実験的に実装

## 締め切り
１：10/31  
２：11/30  
３：12/31

## 全体開発フロー
- issueを立てる
- ブランチを切る
- 開発
- リファクタリング
- 単体テスト
- プルリクを立てる
- プルリクをマージ

## Git開発フロー

１、developからfeatureを分岐し、新機能を開発  
２、エラーや問題が起きたら、devleopからbugを分岐し、解決  
３、リリース可能状態になったら、developをmasterにマージ  

プルリクをマージしたら？
→マージ元のブランチを削除
→developは削除しない

ブランチ名は？
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
