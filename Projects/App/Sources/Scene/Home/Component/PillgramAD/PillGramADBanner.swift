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
        setShadow(
            color: .black,
            opacity: 0.05,
            radius: 10,
            offset: .init(width: 0, height: 4)
        )
    }

    override func addView() {
        addSubview(bannerImageView)
    }

    override func setAutoLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(80)
        }

        bannerImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview()
        }
    }
}

#Preview(body: {
    PillGramADBanner()
})
