// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Moya

enum MedicineAPI {
    case searchMedicine(name: String)
}

extension MedicineAPI: TargetType {
    var baseURL: URL { .init(string: "http://192.168.1.165:8080")! }

    var path: String { "" }

    var method: Moya.Method { .get }

    var validationType: ValidationType { .successCodes }

    var task: Moya.Task {
        switch self {
        case let .searchMedicine(name):
            return .requestParameters(
                parameters: [
                    "name": name,
                    "page": 1
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
}
