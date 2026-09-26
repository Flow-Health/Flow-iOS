// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import Then
import SnapKit
import RxSwift
import RxCocoa

class InfoNavigateButton: UIBarButtonItem {

    private let disposeBag = DisposeBag()
    public let tap = PublishRelay<Void>()

    private lazy var insetButton = BaseButton().then {
        $0.setImage(
            FlowKitAsset.settingGear.image.withTintColor(.black.withAlphaComponent(0.8)),
            for: .normal
        )
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 22
    }

    override init() {
        super.init()
        if #available(iOS 26.0, *) {
            setUpSystemItem()
        } else {
            setUpCustomItem()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// iOS 26: customView 없이 두어 시스템이 리퀴드 글래스 배경을 그리게 한다
    private func setUpSystemItem() {
        image = FlowKitAsset.settingGear.image.withRenderingMode(.alwaysTemplate)
        accessibilityLabel = "설정"

        rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }

    private func setUpCustomItem() {
        customView = insetButton

        insetButton.rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)

        insetButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}
