// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

import SnapKit

open class FlowTextField: BaseTextField {

    let maxLength: Int?

    public init(maxLength: Int? = nil, placeholder: String? = nil) {
        self.maxLength = maxLength

        super.init(frame: .zero)
        self.placeholder = placeholder
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func attribute() {
        backgroundColor = .black6
        layer.cornerRadius = 5

        font = .headerH3SemiBold
        attributedPlaceholder = .init(
            string: self.placeholder ?? "",
            attributes: [.foregroundColor: UIColor.black3, .font: UIFont.headerH3SemiBold]
        )

        let paddingView = UIView(frame: .init(x: 0, y: 0, width: 15, height: 0))
        rightViewMode = .always
        leftViewMode = .always
        rightView = paddingView
        leftView = paddingView

        autocorrectionType = .no
        autocapitalizationType = .none
    }

    open override func bind() {
        self.rx.text.orEmpty
            .map { text in
                guard let maxLength = self.maxLength else { return text }
                return String(text.prefix(maxLength))
            }
            .bind(to: self.rx.text)
            .disposed(by: disposeBag)
    }

    open override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}

#Preview(body: {
    FlowTextField(maxLength: 5, placeholder: "약 이름 입력")
})
