// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model
import Core

import Moya
import RxMoya
import RxSwift

public class PrescriptionMedicineDataSourceImpl: PrescriptionMedicineDataSource {
    
    private let provider = MoyaProvider<MedicineAPI>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    public func searchPrescriptionMedicine(with name: String) -> Single<[PrescriptionMedicineInfoResponse]> {
        provider.rx.request(.searchPrescriptionMedicine(name: name))
            .map(PrescriptionOpenAPIResponse.self)
            .map {
                guard let body = $0.body,
                      let medicineList = body.medicineList
                else { return [] }
                return medicineList
            }
    }
}
