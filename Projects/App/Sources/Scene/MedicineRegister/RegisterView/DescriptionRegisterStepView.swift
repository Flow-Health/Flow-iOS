// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class DescriptionRegisterStepView: BaseView {
    
    private let disposeBag = DisposeBag()

    private let headerView = RegisterHeaderView(
        description: "어떤 약인지 간단하게 설명해주세요.",
        title: "간단한 설명을 작성해주세요."
    )

    let descriptionTextView = FlowTextView(
        maxLength: 400,
        placeholder: "간단한 설명 입력"
    )

    let nextButton = RegisterNextButton(title: "다음")
    let keyboardNextButton = RegisterKeyboardNextButton(title: "다음")

    override var isHidden: Bool {
        didSet {
            if isHidden {
                descriptionTextView.textView.resignFirstResponder()
            }
        }
    }

    override func attribute() {
        backgroundColor = .white
    }

    override func bind() {
        descriptionTextView.textView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(
                with: self,
                onNext: { owner, status in
                    owner.nextButton.isEnabled = status
                    owner.keyboardNextButton.isEnabled = status
                })
            .disposed(by: disposeBag)

        NotificationCenter.keyboardHightObservable
            .subscribe(onNext: setNextButtonPosition)
            .disposed(by: disposeBag)
    }

    override func addView() {
        addSubViews(
            headerView,
            descriptionTextView,
            nextButton,
            keyboardNextButton
        )
    }

    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

extension DescriptionRegisterStepView {
    private func setNextButtonPosition(keyboardHeight: CGFloat) {
        keyboardNextButton.snp.remakeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(keyboardHeight > 0 ? -keyboardHeight : 50)
        }

        UIView.animate(withDuration: 0.46, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.layoutIfNeeded()
        }
    }
}
