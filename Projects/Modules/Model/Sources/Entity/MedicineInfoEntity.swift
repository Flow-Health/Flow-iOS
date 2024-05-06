// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public struct MedicineInfoEntity {
    public let imageURL: String         // 이미지 링크
    public let medicineName: String     // 약 이름
    public let companyName: String      // 약 제조사 이름
    public let itemCode: String         // 품목기준코드
    public let efficacy: String         // 효능
    public let howToUse: String         // 사용법
    public let cautionWarning: String   // 주의사항경고
    public let caution: String          // 주의사항
    public let interaction: String      // 상호작용
    public let sideEffect: String       // 부작용
    public let storageMethod: String    // 보관법
    public let updateDate: String       // 수정일자
    public let tagHexColorCode: String? // 태그색상 헥스 코드

    public init(
        imageURL: String,
        medicineName: String,
        companyName: String,
        itemCode: String,
        efficacy: String,
        howToUse: String,
        cautionWarning: String,
        caution: String,
        interaction: String,
        sideEffect: String,
        storageMethod: String,
        updateDate: String,
        tagHexColorCode: String? = nil
    ) {
        self.imageURL = imageURL
        self.medicineName = medicineName
        self.companyName = companyName
        self.itemCode = itemCode
        self.efficacy = efficacy
        self.howToUse = howToUse
        self.cautionWarning = cautionWarning
        self.caution = caution
        self.interaction = interaction
        self.sideEffect = sideEffect
        self.storageMethod = storageMethod
        self.updateDate = updateDate
        self.tagHexColorCode = tagHexColorCode
    }
}
