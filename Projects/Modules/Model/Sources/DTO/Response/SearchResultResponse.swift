// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

/// 일반약  OpenAPI를 위한 결과 DTO

public struct SearchResultResponse: Decodable {
    public let medicineList: [MedicineInfoResponse]?

    enum CodingKeys: String, CodingKey {
        case medicineList = "items"
    }
}
