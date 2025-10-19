// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import SnapKit
import Then

class ColorPIckerToggleButton: BaseButton {

    var isChecked: Bool {
        set { checkImage.isHidden = !newValue }
        get { checkImage.isHidden }
    }

    var color: PickerColor?

    private let checkImage = UIImageView().then {
        $0.image = FlowKitAsset.whiteCheck.image
        $0.isHidden = true
    }

    init(colorType: PickerColor) {
        super.init(frame: .zero)
        backgroundColor = UIColor(hex: colorType.hexCode)
        color = colorType
        layer.cornerRadius = 15
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func attribute() {
        
    }
    
    override func addView() {
        addSubview(checkImage)
    }

    override func setAutoLayout() {
        checkImage.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.center.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }
}
