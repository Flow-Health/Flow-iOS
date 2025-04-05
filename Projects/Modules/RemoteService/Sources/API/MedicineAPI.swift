// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Core
import Moya

enum MedicineAPI {
    case searchMedicine(name: String, pageNumber: Int)
    case searchPrescriptionMedicine(name: String, pageNumber: Int)
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
        case let .searchMedicine(name, pageNumber):
            return .requestParameters(
                parameters: [
                    "serviceKey": Environment.getValue(key: .openApiServiceKey),
                    "pageNo": pageNumber,
                    "itemName": name,
                    "numOfRows": 10,
                    "type": "json"
                ],
                encoding: URLEncoding.queryString
            )
        case let .searchPrescriptionMedicine(name, pageNumber):
            return .requestParameters(
                parameters: [
                    "serviceKey": Environment.getValue(key: .openApiServiceKey),
                    "pageNo": pageNumber,
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
