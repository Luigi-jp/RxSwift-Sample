//
//  GreetingViewController.swift
//  RxSwift-Sample
//
//  Created by 佐藤瑠偉史 on 2022/04/03.
//

import UIKit
import RxSwift
import RxCocoa

final class GreetingViewController: UIViewController {
    static func makeFromStoryboard() -> GreetingViewController {
        let vc = UIStoryboard.greetingViewController
        return vc
    }

    enum State: Int {
        case userButtons
        case userTextField
    }

    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var stateSegmentControl: UISegmentedControl!
    @IBOutlet private weak var freeTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private var greetingButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // nameTextFieldの入力イベントを監視対象とする
        let nameObservable = nameTextField.rx.text.filterNil()
        // freeTextFieldの入力イベントを監視対象とする

        let freeTextObservable = freeTextField.rx.text.filterNil()
        
        // segmentの切り替えイベントをStateに変換して監視対象とする
        let stateObservable = stateSegmentControl.rx.value.map { selectedIndex in
            State(rawValue: selectedIndex)!
        }

        // segmentの選択状態が自由入力かどうかを監視対象とする
        let freeTextFieldEnabledObservable = stateObservable.map { state in
            state == .userTextField
        }

        // freeTextFieldEnabledObservableのイベントをfreeTextFieldにバインドしてTextFieldの選択可否を変更する
        freeTextFieldEnabledObservable.bind(to: freeTextField.rx.isEnabled).disposed(by: rx.disposeBag)

        // 観測対象を作成し、ボタンの初期選択値を設定。
        let lastSelectedGreeting: BehaviorRelay<String> = BehaviorRelay(value: "こんにちは")

        // 各ボタンに対してイベントのバインドとタップ時の処理を定義
        greetingButtons.forEach { button in
            // freeTextFieldEnabledObservableのイベントをbuttonにバインドしてbuttonの選択可否を変更する
            freeTextFieldEnabledObservable.map { isEnabled in
                !isEnabled
            }.bind(to: button.rx.isEnabled).disposed(by: rx.disposeBag)

            // buttonのタップイベントを監視して、タップされたbuttonの文字をlastSelectedGrrreetingにイベントとして渡す
            button.rx.tap.subscribe(onNext: {
                lastSelectedGreeting.accept(button.currentTitle!)
            }).disposed(by: rx.disposeBag)
        }

        // segmentの変更イベント、freeTextFieldの入力イベント、buttonのタップイベント、nameTextFieldの入力イベントを監視して、いずれかに変更があった場合それぞれの最新値を取得
        // segmentの選択状態に合わせてgreetingLabelに文字列を表示する
        Observable.combineLatest(stateObservable, freeTextObservable, lastSelectedGreeting, nameObservable) { (state, freeWord, selectedGreeting, name) -> String  in
            switch state {
            case .userTextField:
                return freeWord + name
            case .userButtons:
                return selectedGreeting + name
            }
        }.bind(to: greetingLabel.rx.text).disposed(by: rx.disposeBag)
    }
}
