// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Core
import Moya

enum MedicineAPI {
    case searchMedicine(name: String)
    case searchPrescriptionMedicine(name: String)
}

extension MedicineAPI: TargetType {
    var baseURL: URL { .init(string: Environment.getValue(key: .baseURL))! }

    var path: String {
        switch self {
        case .searchMedicine:
            return "/DrbEasyDrugInfoService/getDrbEasyDrugList"
        case .searchPrescriptionMedicine:
            return "/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01"
        }
    }

    var method: Moya.Method { .get }

    var validationType: ValidationType { .successCodes }

    var task: Moya.Task {
        switch self {
        case let .searchMedicine(name):
            return .requestParameters(
                parameters: [
                    "serviceKey": Environment.getValue(key: .openApiServiceKey),
                    "pageNo": 1,
                    "itemName": name,
                    "numOfRows": 10,
                    "type": "json"
                ],
                encoding: URLEncoding.queryString
            )
        case let .searchPrescriptionMedicine(name):
            return .requestParameters(
                parameters: [
                    "serviceKey": Environment.getValue(key: .openApiServiceKey),
                    "pageNo": 1,
                    "item_name": name,
                    "numOfRows": 10,
                    "type": "json"
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {
        ["Content-Type": "application/json;charset=UTF-8"]
    }
}
