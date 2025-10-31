// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import RxSwift
import RxCocoa

class RegisterKeyboardNextButton: UIButton {

    init(title: String?) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = .blue1
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .headerH3Bold
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 버튼 비활성화 시, 배경색 변경
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .blue1 : .black4
        }
    }

    // 클릭시 애니메이션
    override var isHighlighted: Bool {
        willSet {
            UIView.animate(withDuration: 0.08) { [self] in
                layer.opacity = newValue ? 0.7 : 1
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.lessThanOrEqualToSuperview().offset(100)
        }
    }
}
