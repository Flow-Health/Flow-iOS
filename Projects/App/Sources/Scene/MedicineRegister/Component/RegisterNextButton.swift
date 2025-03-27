// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import RxSwift
import RxCocoa

class RegisterNextButton: BaseButton {

    init(title: String?) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func attribute() {
        backgroundColor = .blue1
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .headerH3Bold
    }
    
    // 버튼 비활성화 시, 배경색 변경
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .blue1 : .black4
        }
    }

    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(54)
        }
    }
}

#Preview(body: {
    RegisterNextButton(title: "다음")
})
