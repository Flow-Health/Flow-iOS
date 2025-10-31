// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model
import Core

import Moya
import RxMoya
import RxSwift

public class MedicineContentDataSourceImpl: MedicineContentDataSource {
    
    private let provider = MoyaProvider<MedicineAPI>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    public func searchMedicine(with name: String, _ pageNumber: Int, _ numOfRows: Int) -> Single<[MedicineInfoResponse]> {
        provider.rx.request(.searchMedicine(name: name, pageNumber: pageNumber, numOfRows: numOfRows))
            .map(OpenAPIResponse.self)
            .map {
                guard let body = $0.body,
                      let meidicineList = body.medicineList
                else { return [] }
                return meidicineList
            }
    }
}
