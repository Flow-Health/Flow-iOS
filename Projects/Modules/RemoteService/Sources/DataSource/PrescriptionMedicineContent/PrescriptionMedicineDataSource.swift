// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol PrescriptionMedicineDataSource {
    func searchPrescriptionMedicine(with name: String, _ pageNumber: Int, _ numOfRows: Int) -> Single<[PrescriptionMedicineInfoResponse]>
}
