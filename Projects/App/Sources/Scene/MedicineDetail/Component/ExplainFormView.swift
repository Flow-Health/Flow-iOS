// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class ExplainFormView: VStack {
    private let titleLabel = UILabel().then {
        $0.font = .bodyB1SemiBold
        $0.textColor = .blue1
    }
    private let explainLabel = UILabel().then {
        $0.customLabel("-", font: .bodyB3SemiBold, textColor: .black)
        $0.numberOfLines = 0
    }
    private let paddingView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .black6
    }

    var explain: String? {
        set { explainLabel.text = newValue }
        get { explainLabel.text }
    }

    init(title: String?) {
        super.init(spacing: 5)
        titleLabel.text = title
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        paddingView.addSubview(explainLabel)
        addArrangedSubviews(
            titleLabel,
            paddingView
        )
        explainLabel.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview().inset(15)
        }
        paddingView.snp.makeConstraints {
            $0.bottom.equalTo(explainLabel).offset(15)
        }
    }
}
