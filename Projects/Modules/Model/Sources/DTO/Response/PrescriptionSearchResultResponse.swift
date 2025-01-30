// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

/// 전문약  OpenAPI를 위한 결과 DTO

public struct PrescriptionSearchResultResponse: Decodable {
    public let medicineList: [PrescriptionMedicineInfoResponse]?

    enum CodingKeys: String, CodingKey {
        case medicineList = "items"
    }
}
