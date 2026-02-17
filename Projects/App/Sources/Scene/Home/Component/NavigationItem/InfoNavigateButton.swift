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

    private let insetButton = BaseButton().then {
        $0.setImage(
            FlowKitAsset.settingGear.image.withTintColor(.black.withAlphaComponent(0.8)),
            for: .normal
        )
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 22
    }
    
    override init() {
        super.init()
        customView = insetButton
        applyHidesSharedBackground()
        bind()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        insetButton.rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
    
    private func setAutoLayout() {
        insetButton.snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}
