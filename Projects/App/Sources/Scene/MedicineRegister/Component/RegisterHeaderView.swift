// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit

class RegisterHeaderView: BaseView {
    private let descriptionLabel = UILabel().then {
        $0.font = .bodyB2SemiBold
        $0.textColor = .blue1
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    private let titleLabel = UILabel().then {
        $0.font = .headerH2SemiBold
        $0.textColor = .black
        $0.textAlignment = .left
    }

    init(description: String?, title: String?) {
        super.init(frame: .zero)
        descriptionLabel.text = description
        titleLabel.text = title
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addView() {
        addSubViews(descriptionLabel, titleLabel)
    }

    override func setLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
        }

        self.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
}
