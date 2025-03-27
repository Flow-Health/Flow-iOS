// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import SQLite
import Model
import RxSwift

public class BookMarkMedicineDataSourceImpl: BookMarkMedicineDataSource {

    private let dbManager: DataBaseManager
    private let bookMarkTable = BookMarkMedicineTable.table
    private let medicineTypeTable = MedicineTypeTable.table

    public init() {
        dbManager = DataBaseManager.shared
    }

    public func insertBookMarkMedicine(with entity: MedicineInfoEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            do {
                try dbManager.db?.run(
                    bookMarkTable.insert(
                        BookMarkMedicineTable.itemCode <- entity.itemCode,
                        BookMarkMedicineTable.imageURL <- entity.imageURL,
                        BookMarkMedicineTable.medicineName <- entity.medicineName,
                        BookMarkMedicineTable.companyName <- entity.companyName,
                        BookMarkMedicineTable.efficacy <- entity.efficacy,
                        BookMarkMedicineTable.howToUse <- entity.howToUse,
                        BookMarkMedicineTable.cautionWarning <- entity.cautionWarning,
                        BookMarkMedicineTable.caution <- entity.caution,
                        BookMarkMedicineTable.interaction <- entity.interaction,
                        BookMarkMedicineTable.sideEffect <- entity.sideEffect,
                        BookMarkMedicineTable.storageMethod <- entity.storageMethod,
                        BookMarkMedicineTable.updateDate <- entity.updateDate,
                        BookMarkMedicineTable.tagHexColorCode <- entity.tagHexColorCode
                    )
                )
                completable(.completed)
            } catch { completable(.error(error)) }
            return Disposables.create()
        }
    }
    
    public func deleteBookMarkMedicine(with itemCode: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            let targetRow = bookMarkTable.filter(BookMarkMedicineTable.itemCode == itemCode)
            let targetMedicineTypeRow = medicineTypeTable.filter(MedicineTypeTable.itemCode == itemCode)
            do {
                try dbManager.db?.run(targetRow.delete())
                try dbManager.db?.run(targetMedicineTypeRow.delete())
                completable(.completed)
            } catch { completable(.error(error)) }
            return Disposables.create()
        }
    }
    
    public func fetchBookMarkMedicineList() -> Single<[MedicineInfoEntity]> {
        let query = bookMarkTable
            .join(
                medicineTypeTable,
                on: bookMarkTable[BookMarkMedicineTable.itemCode] == medicineTypeTable[MedicineTypeTable.itemCode]
            )

        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }

            do {
                let resultEntity = try dbManager.db?.prepare(query).map {
                    MedicineInfoEntity(
                        imageURL: $0[BookMarkMedicineTable.imageURL],
                        medicineName: $0[BookMarkMedicineTable.medicineName],
                        companyName: $0[BookMarkMedicineTable.companyName],
                        itemCode: $0[BookMarkMedicineTable.itemCode],
                        efficacy: $0[BookMarkMedicineTable.efficacy],
                        howToUse: $0[BookMarkMedicineTable.howToUse],
                        cautionWarning: $0[BookMarkMedicineTable.cautionWarning],
                        caution: $0[BookMarkMedicineTable.caution],
                        interaction: $0[BookMarkMedicineTable.interaction],
                        sideEffect: $0[BookMarkMedicineTable.sideEffect],
                        storageMethod: $0[BookMarkMedicineTable.storageMethod],
                        updateDate: $0[BookMarkMedicineTable.updateDate],
                        tagHexColorCode: $0[BookMarkMedicineTable.tagHexColorCode],
                        medicineType: MedicineTypeEnum(rawValue: $0[MedicineTypeTable.medicineType]) ?? .NOMAL
                    )
                }
                single(.success(resultEntity ?? []))
            } catch { single(.failure(error)) }
            return Disposables.create()
        }
    }
    
    public func findBookMarkMedicine(with itemCode: String) -> Single<MedicineInfoEntity?> {
        
        let query = bookMarkTable
            .join(
                medicineTypeTable,
                on: bookMarkTable[BookMarkMedicineTable.itemCode] == medicineTypeTable[MedicineTypeTable.itemCode]
            )
        
        return Single.create { [weak self]  single in
            guard let self else { return Disposables.create() }
            let targetRow = query.filter(BookMarkMedicineTable.itemCode == itemCode)
            do {
                let resultEntity = try dbManager.db?.prepare(targetRow).map {
                    MedicineInfoEntity(
                        imageURL: $0[BookMarkMedicineTable.imageURL],
                        medicineName: $0[BookMarkMedicineTable.medicineName],
                        companyName: $0[BookMarkMedicineTable.companyName],
                        itemCode: $0[BookMarkMedicineTable.itemCode],
                        efficacy: $0[BookMarkMedicineTable.efficacy],
                        howToUse: $0[BookMarkMedicineTable.howToUse],
                        cautionWarning: $0[BookMarkMedicineTable.cautionWarning],
                        caution: $0[BookMarkMedicineTable.caution],
                        interaction: $0[BookMarkMedicineTable.interaction],
                        sideEffect: $0[BookMarkMedicineTable.sideEffect],
                        storageMethod: $0[BookMarkMedicineTable.storageMethod],
                        updateDate: $0[BookMarkMedicineTable.updateDate],
                        tagHexColorCode: $0[BookMarkMedicineTable.tagHexColorCode],
                        medicineType: MedicineTypeEnum(rawValue: $0[MedicineTypeTable.medicineType]) ?? .NOMAL
                    )
                }
                single(.success(resultEntity?.first))
            } catch { single(.failure(error)) }
            return Disposables.create()
        }
    }

    public func updateBookMarkMedicine(to entity: MedicineInfoEntity, at itemCode: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            let targetRow = bookMarkTable.filter(BookMarkMedicineTable.itemCode == itemCode)
            do {
                try dbManager.db?.run(targetRow.update(
                    BookMarkMedicineTable.itemCode <- entity.itemCode,
                    BookMarkMedicineTable.imageURL <- entity.imageURL,
                    BookMarkMedicineTable.medicineName <- entity.medicineName,
                    BookMarkMedicineTable.companyName <- entity.companyName,
                    BookMarkMedicineTable.efficacy <- entity.efficacy,
                    BookMarkMedicineTable.howToUse <- entity.howToUse,
                    BookMarkMedicineTable.cautionWarning <- entity.cautionWarning,
                    BookMarkMedicineTable.caution <- entity.caution,
                    BookMarkMedicineTable.interaction <- entity.interaction,
                    BookMarkMedicineTable.sideEffect <- entity.sideEffect,
                    BookMarkMedicineTable.storageMethod <- entity.storageMethod,
                    BookMarkMedicineTable.updateDate <- entity.updateDate,
                    BookMarkMedicineTable.tagHexColorCode <- entity.tagHexColorCode
                ))
                completable(.completed)
            } catch { completable(.error(error)) }
            return Disposables.create()
        }
    }
}
