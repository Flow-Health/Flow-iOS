// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import RxSwift
import RxCocoa

class ReceiptOcrEndViewController: BaseVC<ReceiptOcrEndViewModel> {

    private let titleLabel = UILabel().then {
        $0.text = "약을 추가하였습니다!"
        $0.font = .headerH2SemiBold
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private let subTitleLabel = UILabel().then {
        let text = "홈 > 자주 먹는 약 에서 추가한 약을 확인하세요."
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(
            [.foregroundColor: UIColor.blue1, .font: UIFont.bodyB2Bold],
            range: (text as NSString).range(of: "홈 > 자주 먹는 약")
        )
        
        $0.text = text
        $0.font = .bodyB2SemiBold
        $0.textColor = .black2
        $0.textAlignment = .center
        $0.attributedText = attributedString
    }
    
    private let pillImageView = UIImageView().then {
        $0.image = FlowKitAsset.pill.image
    }

    let closeButton = FlowNextButton(title: "홈으로 이동")

    override func bind() {
        let input = ReceiptOcrEndViewModel.Input(
            tapCloseButton: closeButton.rx.tap.asObservable()
        )
        let _ = viewModel.transform(input: input)
    }

    override func attridute() {
        navigationItem.hidesBackButton = true
    }

    override func addView() {
        view.addSubViews(
            titleLabel,
            subTitleLabel,
            pillImageView,
            closeButton
        )
    }

    override func setAutoLayout() {

        pillImageView.snp.makeConstraints {
            $0.size.equalTo(108)
            $0.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(subTitleLabel.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(pillImageView.snp.top).offset(-58)
            $0.centerX.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}
