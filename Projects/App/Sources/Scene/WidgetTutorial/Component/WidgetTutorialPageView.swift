// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class WidgetTutorialPageView: BaseView {

    private let imageContainerView = UIView().then {
        $0.backgroundColor = .blue5
        $0.layer.cornerRadius = 24
    }
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    private let stepLabel = PaddingLableView().then {
        $0.layer.cornerRadius = 6
    }
    private let titleLabel = UILabel().then {
        $0.customLabel(font: .headerH3Bold, textColor: .black)
        $0.numberOfLines = 0
    }
    private let descriptionLabel = UILabel().then {
        $0.customLabel(font: .bodyB2Medium, textColor: .black2)
        $0.numberOfLines = 0
    }

    init(step: WidgetTutorialStep) {
        super.init(frame: .zero)
        imageView.image = step.image
        stepLabel.contentText = "STEP \(step.rawValue + 1)"
        titleLabel.text = step.title
        descriptionLabel.text = step.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            imageContainerView,
            stepLabel,
            titleLabel,
            descriptionLabel
        )
        imageContainerView.addSubview(imageView)
    }

    override func setAutoLayout() {
        imageContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        stepLabel.snp.makeConstraints {
            $0.top.equalTo(imageContainerView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(22)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.bottom.equalToSuperview().inset(66)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}
