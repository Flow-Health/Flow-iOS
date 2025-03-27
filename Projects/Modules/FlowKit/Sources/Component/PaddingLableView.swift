// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import SnapKit
import Then

public enum TagType {
    case Common, Primary, Secondary

    var backgroundColor: UIColor {
        switch self {
        case .Common: return .blue5
        case .Primary: return .blue1
        case .Secondary: return .white
        }
    }

    var textColor: UIColor {
        switch self {
        case .Common: return .blue1
        case .Primary: return .white
        case .Secondary: return .blue1
        }
    }

    var borderColor: UIColor {
        switch self {
        case .Common: return .clear
        case .Primary: return .clear
        case .Secondary: return .blue1
        }
    }
}

public class PaddingLableView: UIView {
    private let contentLabel = UILabel().then {
        $0.font = .captionC2SemiBold
        $0.textColor = .blue1
    }
    
    public var contentText: String? {
        set {
            contentLabel.text = newValue
            settingLayout()
        }
        get { contentLabel.text }
    }

    public func setTagType(tagType: TagType) {
        contentLabel.textColor = tagType.textColor
        backgroundColor = tagType.backgroundColor
        layer.borderColor = tagType.borderColor.cgColor
    }

    public init(tagType: TagType = .Common) {
        super.init(frame: .zero)
        backgroundColor = tagType.backgroundColor
        contentLabel.textColor = tagType.textColor
        layer.borderWidth = 1
        layer.borderColor = tagType.borderColor.cgColor
        layer.cornerRadius = 3
        settingLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func settingLayout() {
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.top.equalTo(contentLabel).offset(-4)
            $0.bottom.equalTo(contentLabel).offset(4)
            $0.trailing.equalTo(contentLabel).offset(8)
        }
    }
}
