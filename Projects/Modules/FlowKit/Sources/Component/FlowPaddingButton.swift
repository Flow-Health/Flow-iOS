// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import SnapKit

public class FlowPaddingButton: BaseButton {

    private let customTitleLabel = UILabel().then {
        $0.customLabel(font: .captionC1SemiBold, textColor: .blue1)
    }

    public init(buttonTitle: String?) {
        super.init(frame: .zero)
        backgroundColor = .blue5
        titleLabel?.font = .captionC1SemiBold
        setTitle(buttonTitle, for: .normal)
        customTitleLabel.text = title(for: .normal)
        layer.cornerRadius = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addView() {
        addSubview(customTitleLabel)
    }

    public override func setLayout() {
        customTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(92)
        }
    }
}
