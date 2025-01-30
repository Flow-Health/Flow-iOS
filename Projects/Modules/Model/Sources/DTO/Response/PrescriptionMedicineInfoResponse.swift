// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

/// 전문약  OpenAPI를 위한 상세정보 DTO

/*
 {
                 "ITEM_SEQ": "199001012",
                 "ITEM_NAME": "보령아스트릭스캡슐100밀리그람(아스피린)",
                 "ENTP_SEQ": "19880005",
                 "ENTP_NAME": "(주)보령",
                 "CHART": "이 약은 흰색의 장용피 구형입자가 든 상하주황색의 투명한 경질캡슐.",
                 "ITEM_IMAGE": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/154599017940000101",
                 "PRINT_FRONT": "AST 100",
                 "PRINT_BACK": null,
                 "DRUG_SHAPE": "장방형",
                 "COLOR_CLASS1": "주황, 투명",
                 "COLOR_CLASS2": "주황, 투명",
                 "LINE_FRONT": null,
                 "LINE_BACK": null,
                 "LENG_LONG": "14.2",
                 "LENG_SHORT": "5.05",
                 "THICK": "5.32",
                 "IMG_REGIST_TS": "20041126",
                 "CLASS_NO": "02190",
                 "CLASS_NAME": "기타의 순환계용약",
                 "ETC_OTC_NAME": "일반의약품",
                 "ITEM_PERMIT_DATE": "19900829",
                 "FORM_CODE_NAME": "장용성캡슐제, 펠렛",
                 "MARK_CODE_FRONT_ANAL": "",
                 "MARK_CODE_BACK_ANAL": "",
                 "MARK_CODE_FRONT_IMG": "",
                 "MARK_CODE_BACK_IMG": "",
                 "ITEM_ENG_NAME": "Boryung Astrix Cap. 100mg(Aspirine)",
                 "CHANGE_DATE": "20240611",
                 "MARK_CODE_FRONT": null,
                 "MARK_CODE_BACK": null,
                 "EDI_CODE": null,
                 "BIZRNO": "1348502031"
             }
 */
public struct PrescriptionMedicineInfoResponse: Decodable {
    public let imageURL: String?
    public let medicineName: String?
    public let companyName: String?
    public let itemCode: String?
    public let updateDate: String?
    public let medicineType: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "ITEM_IMAGE"
        case medicineName = "ITEM_NAME"
        case companyName = "ENTP_NAME"
        case itemCode = "ITEM_SEQ"
        case updateDate = "CHANGE_DATE"
        case medicineType = "ETC_OTC_NAME"
    }
}

public extension PrescriptionMedicineInfoResponse {
    func toDomain() -> MedicineInfoEntity {
        .init(
            imageURL: imageURL ?? "-",
            medicineName: medicineName ?? "-",
            companyName: companyName ?? "-",
            itemCode: itemCode ?? "-",
            efficacy: "-",
            howToUse: "-",
            cautionWarning: "-",
            caution: "-",
            interaction: "-",
            sideEffect: "-",
            storageMethod: "-",
            updateDate: toDateFormat(with: updateDate) ?? "-",
            medicineType: MedicineTypeEnum(rawValue: medicineType ?? "") ?? .NOMAL
        )
    }

    private func toDateFormat(with str: String?) -> String? {
        let year = str?.prefix(4)
        let mounth = str?.suffix(4).prefix(2)
        let date = str?.suffix(2)

        return [year, mounth, date].map {
            guard let res = $0 else { return "" }
            return String(res)
        }.joined(separator: "-")
    }
}
