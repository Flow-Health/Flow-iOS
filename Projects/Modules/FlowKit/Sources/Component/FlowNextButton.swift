// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

public class FlowNextButton: BaseButton {

    public init(title: String?) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        backgroundColor = .blue1
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .headerH3Bold
    }
    
    // 버튼 비활성화 시, 배경색 변경
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .blue1 : .black4
        }
    }

    public override func setAutoLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(54)
        }
    }
}

#Preview(body: {
    FlowNextButton(title: "다음")
})
