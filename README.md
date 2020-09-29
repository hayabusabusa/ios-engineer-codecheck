# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 概要

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に iOS エンジニアを希望する方に出す課題のベースプロジェクトです。本課題が与えられた方は、下記の概要を詳しく読んだ上で課題を取り組んでください。

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：基本最新の安定版（本概要作成時点では Xcode 11.4.1）
- Swift：基本最新の安定版（本概要作成時点では Swift 5.1）
- 開発ターゲット：基本最新の安定版（本概要作成時点では iOS 13.4）
- サードパーティーライブラリーの利用：オープンソースのものに限り制限しない

### 動作

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

## 課題取り組み方法

Issues を確認した上、本プロジェクトを [**Duplicate** してください](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)（Fork しないようにしてください。必要ならプライベートリポジトリーにしても大丈夫です）。今後のコミットは全てご自身のリポジトリーで行ってください。

コードチェックの課題 Issue は全て [`課題`](https://github.com/yumemi/ios-engineer-codecheck/milestone/1) Milestone がついており、難易度に応じて Label が [`初級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A初級+milestone%3A課題)、[`中級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A中級+milestone%3A課題+) と [`ボーナス`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3Aボーナス+milestone%3A課題+) に分けられています。課題の必須／選択は下記の表とします：

|   | 初級 | 中級 | ボーナス
|--:|:--:|:--:|:--:|
| 新卒／未経験者 | 必須 | 選択 | 選択 |
| 中途／経験者 | 必須 | 必須 | 選択 |

課題が完成したら、リポジトリーのアドレスを教えてください。

---

## 追加した機能

以下の機能を追加で実装しました。

- ページネーションの実装
- ロード中、データが空の時の表示を追加
- リポジトリを `SFSafariViewContoller` で表示
- ダークモードの対応

| 検索前(Light) | 検索前(Dark) | 検索後(Light) | 検索後(Dark) |
| :----------: | :---------: | :----------: | :---------: |
| ![Simulator Screen Shot - iPhone 11 - 2020-09-29 at 19 56 53](https://user-images.githubusercontent.com/31949692/94552320-a5329080-0291-11eb-9919-5018ca44f733.png) | ![Simulator Screen Shot - iPhone 11 - 2020-09-29 at 19 57 17](https://user-images.githubusercontent.com/31949692/94552352-af548f00-0291-11eb-9fbd-8bf2e080be4a.png) | ![Simulator Screen Shot - iPhone 11 - 2020-09-29 at 19 57 31](https://user-images.githubusercontent.com/31949692/94552377-bb405100-0291-11eb-9dd6-1664d671c315.png) | ![Simulator Screen Shot - iPhone 11 - 2020-09-29 at 19 57 37](https://user-images.githubusercontent.com/31949692/94552437-d3b06b80-0291-11eb-8a31-d9ef86ab16b7.png) |

| リポジトリ詳細(Light) | リポジトリ詳細(Dark) |
| :----------------: | :----------------: |
| ![Simulator Screen Shot - iPhone 11 - 2020-09-29 at 19 57 46](https://user-images.githubusercontent.com/31949692/94552584-12462600-0292-11eb-816d-423ced60afa4.png) | ![Simulator Screen Shot - iPhone 11 - 2020-09-29 at 19 57 52](https://user-images.githubusercontent.com/31949692/94552618-1e31e800-0292-11eb-967b-cdfb0bc397ee.png) |

## 事前準備

### Carthage

本アプリでは [Carthage](https://github.com/Carthage/Carthage) を使用して以下のサードパーティー製ライブラリを管理しています。  
インストールした上でプロジェクトがあるフォルダで以下のコマンドを実行し、ライブラリのインストールを行ってください。

- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Kingfisher](https://github.com/onevcat/Kingfisher)

```Shell
carthage bootstrap --platform iOS
```

**⚠️ Xcode12 の場合**

2020/9/25 現在、Xcode12 で Carthage のビルドを行うと失敗する場合があります。( [公式の issue](https://github.com/Carthage/Carthage/issues/3019) )  
よってワークアラウンドとしてプロジェクトがあるフォルダで以下のコマンドを実行してビルドを行ってください。

```Shell
sh ./carthage-build.sh bootstrap --platform iOS
```

### Mint

本アプリでは以下のツールを [Mint](https://github.com/yonaskolb/Mint) を利用して管理しています。  
Mint をインストールした上で以下のコマンドを実行し、ツールをインストールしてください。

- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)

```Shell
mint bootstrap
```

## 設計

本アプリでは RxSwift を用いた MVVM アーキテクチャーを採用しています。  
**Model**、**ViewModel**、**View** はそれぞれ以下の役割を担っています。  

### Model

- ビジネスロジックの実行
- 結果として得られたデータの保持
- データの更新等を **ViewModel** に通知

**ViewModel** の肥大化を防ぐために **Model** でデータの保持、更新の通知を行うようにしました。  
**Model** の作りは[こちらの記事](https://qiita.com/Kuniwak/items/015cddcf37e854713a2e)を参考にしました。

### ViewModel

- **Model** と **View** の橋渡し
- **Model** から受け取ったデータを表示可能なデータに変換

**ViewModel** の作りは [Kickstarter の OSS](https://github.com/kickstarter/ios-oss/tree/master/Kickstarter-iOS) を参考にしました。  

### View

- レイアウト等の描画に関する処理
- ユーザーからの入力を受け付ける
- **ViewModel** から出力されるデータのバインディング

## プロジェクト構成

```
ProjectRoot
    ┠ Network # API 通信関連
    ┠ Repository # ビジネスロジックを機能ごとにまとめた Repository 
    ┠ Model # MVVM における Model
    ┠ View # ViewControllerとStoryboard、xibのUI関連
    ┠ ViewModel # MVVM における ViewModel
    ┠ Common # ユーティリティや Extension
    ┗ Generated # SwiftGen で生成されたファイル
```