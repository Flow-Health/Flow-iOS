// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit

enum WidgetTutorialStep: Int, CaseIterable {
    case longPressHome
    case openWidgetGallery
    case searchFlow
    case addWidget
    case selectMedicine

    var title: String {
        switch self {
        case .longPressHome: "홈 화면을 길게 눌러주세요"
        case .openWidgetGallery: "위젯 추가 메뉴를 열어주세요"
        case .searchFlow: "Flow를 검색해주세요"
        case .addWidget: "원하는 위젯을 추가해주세요"
        case .selectMedicine: "기록할 약을 선택해주세요"
        }
    }

    var description: String {
        switch self {
        case .longPressHome:
            "아이폰 홈 화면의 빈 공간을 앱 아이콘이 흔들릴 때까지 길게 누릅니다."
        case .openWidgetGallery:
            // 홈 화면 편집 메뉴가 iOS 18부터 '편집 > 위젯 추가'로 바뀜
            if #available(iOS 18.0, *) {
                "왼쪽 위의 '편집' 버튼을 누른 뒤 '위젯 추가'를 선택합니다."
            } else {
                "왼쪽 위의 '+' 버튼을 누릅니다."
            }
        case .searchFlow:
            "위젯 검색창에 'Flow'를 입력하고 목록에서 Flow를 선택합니다."
        case .addWidget:
            "좌우로 넘겨 '약 기록' 또는 '기록 확인' 위젯과 크기를 고른 뒤 '위젯 추가'를 누릅니다."
        case .selectMedicine:
            "'약 기록' 위젯은 추가한 위젯을 길게 눌러 '위젯 편집'에서 기록할 약을 선택해야 사용할 수 있습니다."
        }
    }

    var image: UIImage {
        switch self {
        case .longPressHome:
            FlowKitAsset.widgetTutorialStep1.image
        case .openWidgetGallery:
            if #available(iOS 18.0, *) {
                FlowKitAsset.widgetTutorialStep2.image
            } else {
                FlowKitAsset.widgetTutorialStep2Legacy.image
            }
        case .searchFlow:
            FlowKitAsset.widgetTutorialStep3.image
        case .addWidget:
            FlowKitAsset.widgetTutorialStep4.image
        case .selectMedicine:
            FlowKitAsset.widgetTutorialStep5.image
        }
    }
}
