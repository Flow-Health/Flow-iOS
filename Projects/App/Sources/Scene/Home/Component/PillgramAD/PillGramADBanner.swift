// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit

class PillGramADBanner: BaseButton {
    private let bannerImageView = UIImageView().then {
        $0.image = UIImage(named: "PillGramBanner")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.contentMode = .scaleAspectFit
    }
    
    override func attribute() {
        layer.cornerRadius = 20
        backgroundColor = .white
    }

    override func addView() {
        addSubview(bannerImageView)
    }

    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(80)
        }

        bannerImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(1)
            $0.leading.equalToSuperview().inset(0)
            $0.trailing.equalToSuperview()
        }
    }
}

#Preview(body: {
    PillGramADBanner()
})
