// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class LastTakenTimeView: BaseView {
    private let lastTakenTitleLabel = UILabel().then {
        $0.customLabel("마지막 복용시간", font: .captionC1Medium, textColor: .black)
    }

    private let lastTakenTimeLabel = UILabel().then {
        $0.text = "--:--"
        $0.font = .headerH1Bold
        $0.textColor = .blue1
    }

    private let imageClipView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    private let logoImageView = UIImageView(image: UIImage(named: "PointLogo"))

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 20
        setShadow(
            color: .black,
            opacity: 0.05,
            radius: 10,
            offset: .init(width: 0, height: 4)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        imageClipView.addSubview(logoImageView)
        addSubViews(
            lastTakenTitleLabel,
            lastTakenTimeLabel,
            imageClipView
        )
    }

    override func setLayout() {
        lastTakenTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(20)
        }
        lastTakenTimeLabel.snp.makeConstraints {
            $0.top.equalTo(lastTakenTitleLabel.snp.bottom)
            $0.leading.equalTo(lastTakenTitleLabel)
        }
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-4)
            $0.trailing.equalToSuperview().offset(10)
        }
        imageClipView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(lastTakenTimeLabel.snp.bottom).offset(25)
        }
    }
}

extension LastTakenTimeView {
    func setLastTime(_ time: Date?) {
        guard let time else { return }
        lastTakenTimeLabel.text = time.toString(.nomal)
    }
}
