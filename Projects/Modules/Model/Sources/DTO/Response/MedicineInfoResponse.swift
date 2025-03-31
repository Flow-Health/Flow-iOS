// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

/// 일반약  OpenAPI를 위한 상세정보 DTO

public struct MedicineInfoResponse: Decodable {
    public let imageURL: String?
    public let medicineName: String?
    public let companyName: String?
    public let itemCode: String?
    public let efficacy: String?
    public let howToUse: String?
    public let cautionWarning: String?
    public let caution: String?
    public let interaction: String?
    public let sideEffect: String?
    public let storageMethod: String?
    public let updateDate: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "itemImage"
        case medicineName = "itemName"
        case companyName = "entpName"
        case itemCode = "itemSeq"
        case efficacy = "efcyQesitm"
        case howToUse = "useMethodQesitm"
        case cautionWarning = "atpnWarnQesitm"
        case caution = "atpnQesitm"
        case interaction = "intrcQesitm"
        case sideEffect = "seQesitm"
        case storageMethod = "depositMethodQesitm"
        case updateDate = "updateDe"
    }
}

public extension MedicineInfoResponse {
    func toDomain() -> MedicineInfoEntity {
        return .init(
            imageURL: toTrimString(imageURL),
            medicineName: toTrimString(medicineName),
            companyName: toTrimString(companyName),
            itemCode: toTrimString(itemCode),
            efficacy: toTrimString(efficacy),
            howToUse: toTrimString(howToUse),
            cautionWarning: toTrimString(cautionWarning),
            caution: toTrimString(caution),
            interaction: toTrimString(interaction),
            sideEffect: toTrimString(sideEffect),
            storageMethod: toTrimString(storageMethod),
            updateDate: toTrimString(updateDate),
            medicineType: .NOMAL
        )
    }

    private func toTrimString(_ content: String?) -> String {
        guard let content else { return "-" }

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
