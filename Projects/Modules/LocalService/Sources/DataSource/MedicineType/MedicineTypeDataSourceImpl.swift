// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift
import SQLite

public class MedicineTypeDataSourceImpl: MedicineTypeDataSource {
    private let dbManager: DataBaseManager
    private let medicineTypeTable = MedicineTypeTable.table

    public init() {
        dbManager = DataBaseManager.shared
    }
    
    public func insertMedicineType(with itemCode: String, type medicineType: MedicineTypeEnum) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            do {
                try dbManager.db?.run(
                    medicineTypeTable.insert(
                        MedicineTypeTable.itemCode <- itemCode,
                        MedicineTypeTable.medicineType <- medicineType.rawValue
                    )
                )
                completable(.completed)
            } catch { completable(.error(error)) }
            return Disposables.create()
        }
    }
}
