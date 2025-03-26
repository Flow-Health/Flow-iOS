// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

open class FlowTextView: BaseView {
    
    public let textView = UITextView().then {
        $0.font = .bodyB1Medium
        $0.textColor = .black
        $0.backgroundColor = .black6
        $0.layer.cornerRadius = 5
        $0.contentInset = .init(top: 12, left: 15, bottom: 12, right: 15)

        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
        $0.showsVerticalScrollIndicator = false
    }

    private let textViewVstack = VStack(spacing: 5)

    private let placehorderLabel = UILabel().then {
        $0.font = .bodyB1Medium
        $0.textColor = .black3
        $0.textAlignment = .left
    }

    private let counterLabel = UILabel().then {
        $0.font = .bodyB3Medium
        $0.textColor = .blue1
        $0.textAlignment = .right
    }

    private let maxLength: Int?
    
    public init(maxLength: Int? = nil, placeholder: String? = nil) {
        self.maxLength = maxLength

        super.init(frame: .zero)
        placehorderLabel.text = placeholder
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func bind() {
        textView.rx.text.orEmpty
            .map { text in
                guard let maxLength = self.maxLength else { return text }
                return String(text.prefix(maxLength))
            }
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)

        textView.rx.text.orEmpty
            .map { text in
                guard let maxLength = self.maxLength else { return "" }
                return "\(text.count)/\(maxLength)"
            }
            .bind(to: counterLabel.rx.text)
            .disposed(by: disposeBag)

        textView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: placehorderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

    open override func addView() {
        addSubview(textViewVstack)
        textViewVstack.addArrangedSubview(textView)

        // maxLength가 설정되어 있을때, counterLabel 추가하기
        if maxLength != nil {
            textViewVstack.addArrangedSubview(counterLabel)
        }

        textView.addSubview(placehorderLabel)
    }

    open override func setLayout() {

        textViewVstack.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        textView.snp.makeConstraints {
            $0.height.equalTo(180)
        }

        placehorderLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }

        self.snp.makeConstraints {
            $0.bottom.equalTo(textViewVstack)
        }
    }
}

#Preview(body: {
    FlowTextView(maxLength: 1000, placeholder: "약 설명 입력")
})
