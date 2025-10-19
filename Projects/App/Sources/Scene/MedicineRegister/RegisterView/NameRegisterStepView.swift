// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class NameRegisterStepView: BaseView {

    private let headerView = RegisterHeaderView(
        description: "기록할 때 어떤 약인지 알기위해 필요해요",
        title: "약의 이름을 입력해주세요."
    )

    let nameTextField = FlowTextField(
        maxLength: 15,
        placeholder: "약 이름 입력"
    )

    let nextButton = RegisterNextButton(title: "다음")
    let keyboardNextButton = RegisterKeyboardNextButton(title: "다음")

    override var isHidden: Bool {
        didSet {
            if isHidden {
                nameTextField.resignFirstResponder()
            }
        }
    }

    override func attribute() {
        backgroundColor = .white
    }

    override func bind() {
        nameTextField.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(
                with: self,
                onNext: { owner, status in
                    owner.nextButton.isEnabled = status
                    owner.keyboardNextButton.isEnabled = status
                })
            .disposed(by: disposeBag)

        NotificationCenter.keyboardHightObservable
            .skip(while: { $0 == 0.0 })
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                setNextButtonPosition(keyboardHeight: $0)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        addSubViews(
            headerView,
            nameTextField,
            nextButton,
            keyboardNextButton
        )
    }

    override func setAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}

extension NameRegisterStepView {
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
