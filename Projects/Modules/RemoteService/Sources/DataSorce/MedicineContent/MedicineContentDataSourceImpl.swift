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

    public func searchMedicine(with name: String) -> Single<[MedicineInfoResponse]> {
        provider.rx.request(.searchMedicine(name: name))
            .map(SearchResultResponse.self)
            .map { $0.medicineList }
    }
}
