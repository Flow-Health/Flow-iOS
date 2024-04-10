// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift
import SQLite

public class TakenMedicineDataSourceImpl: TakenMedicineDataSource {

    private let dbManager: DataBaseManager?
    private let bookMarkTable = BookMarkMedicineTable.table
    private let takenMedicineTable = TakenMedicineTable.table

    public init() {
        dbManager = DataBaseManager.shared
    }

    public func insertTakenMedicine(with itemCode: String, at takenTime: Date) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            do {
                try dbManager?.db?.run(
                    takenMedicineTable.insert(
                        TakenMedicineTable.itemCode <- itemCode,
                        TakenMedicineTable.medicineTakenTime <- takenTime
                    )
                )
                completable(.completed)
            } catch { completable(.error(error)) }
            return Disposables.create()
        }
    }
    
    public func fetchTakenMedicineList() -> Single<[MedicineTakenEntity]> {
        let query = takenMedicineTable
            .join(
                bookMarkTable,
                on: takenMedicineTable[TakenMedicineTable.itemCode] == bookMarkTable[BookMarkMedicineTable.itemCode]
            )
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            do {
                let result = try dbManager?.db?.prepare(query).map {
                    MedicineTakenEntity(
                        takenTime: $0[TakenMedicineTable.medicineTakenTime],
                        medicineInfo: .init(
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
                            updateDate: $0[BookMarkMedicineTable.updateDate]
                        )
                    )
                }
                single(.success(result ?? []))
            } catch { single(.failure(error)) }
            return Disposables.create()
        }
    }
    
    public func fetchMedicineRecode() -> Single<MedicineRecodeEntity?> {
        let query = takenMedicineTable
            .join(
                bookMarkTable,
                on: takenMedicineTable[TakenMedicineTable.itemCode] == bookMarkTable[BookMarkMedicineTable.itemCode]
            )
            .order(TakenMedicineTable.medicineTakenTime.desc)
            .limit(3)

        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            do {
                let recodeData = try dbManager?.db?.prepare(query).map {
                    (date: $0[TakenMedicineTable.medicineTakenTime],
                     name: $0[BookMarkMedicineTable.medicineName],
                     itemCode: $0[TakenMedicineTable.medicineTakenTime].description)
                }
                let nameList = recodeData?.map { (name: $0.name, id: $0.itemCode) }

                guard let lastTime = recodeData?.first?.date,
                      let nameList = nameList else {
                    single(.success(nil))
                    return Disposables.create()
                }

                let result: MedicineRecodeEntity = .init(
                    lastTakenTime: lastTime,
                    recentMedicineNameList: nameList
                )
                single(.success(result))
            } catch { single(.failure(error)) }
            return Disposables.create()
        }
    }
}
