// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol MedicineContentDataSource {
    func searchMedicine(with name: String) -> Single<[MedicineInfoResponse]>
}
