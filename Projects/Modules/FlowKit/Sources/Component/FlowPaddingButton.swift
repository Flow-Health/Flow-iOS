// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import SnapKit

public class FlowPaddingButton: BaseButton {

    public init(buttonTitle: String?) {
        super.init(frame: .zero)
        backgroundColor = .blue5
        titleLabel?.font = .captionC1SemiBold
        setTitle(buttonTitle, for: .normal)
        setTitleColor(.blue1, for: .normal)
        layer.cornerRadius = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func setAutoLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(92)
        }
    }
}

#Preview(body: {
    FlowPaddingButton(buttonTitle: "Test")
})
