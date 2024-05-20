// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public struct SearchResultResponse: Decodable {
    public let medicineList: [MedicineInfoResponse]

    enum CodingKeys: String, CodingKey {
        case medicineList = "items"
    }
}
