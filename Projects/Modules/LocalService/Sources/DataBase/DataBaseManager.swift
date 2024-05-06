// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import SQLite

protocol DataBaseTable {
    static var table: Table { get set }
}

struct BookMarkMedicineTable: DataBaseTable {
    static var table = Table("book_mark_medicine")

    static let itemCode = Expression<String>("itemCode")
    static let imageURL = Expression<String>("imageURL")
    static let medicineName = Expression<String>("medicineName")
    static let companyName = Expression<String>("companyName")
    static let efficacy = Expression<String>("efficacy")
    static let howToUse = Expression<String>("howToUse")
    static let cautionWarning = Expression<String>("cautionWarning")
    static let caution = Expression<String>("caution")
    static let interaction = Expression<String>("interaction")
    static let sideEffect = Expression<String>("sideEffect")
    static let storageMethod = Expression<String>("storageMethod")
    static let updateDate = Expression<String>("updateDate")
    static let tagHexColorCode = Expression<String?>("tagHexColorCode")
}

struct TakenMedicineTable: DataBaseTable {
    static var table = Table("taken_medicine")

    static let medicineTakenTime =  Expression<Date>("medicineTakenTime")
    static let itemCode = Expression<String>("medicineCode")
}

final class DataBaseManager {
    static let shared = DataBaseManager()
    private(set) var db: Connection?

    private init() {
        do {
            let fileSystem = FileManager.default
            guard let fileURL = fileSystem.containerURL(forSecurityApplicationGroupIdentifier: "group.com.flow-health.flowApp")?
                .appending(path: "SQlite", directoryHint: .isDirectory) else {
                fatalError("fail to fileURL")
            }
            try? fileSystem.createDirectory(at: fileURL, withIntermediateDirectories: false)
            let dbURL = fileURL.appending(path: "db.sqlite3")

            db = try Connection(dbURL.absoluteString)
            guard let db else { fatalError("fail to connect DataBase.") }
            debugPrint("[succes connet DB] Path: \(dbURL.absoluteString)")

            let bookMarkTable = BookMarkMedicineTable.table
            let takenMedicineTable = TakenMedicineTable.table

            try db.run(bookMarkTable.create(ifNotExists: true) {
                $0.column(BookMarkMedicineTable.itemCode, primaryKey: true)
                $0.column(BookMarkMedicineTable.imageURL)
                $0.column(BookMarkMedicineTable.medicineName)
                $0.column(BookMarkMedicineTable.companyName)
                $0.column(BookMarkMedicineTable.efficacy)
                $0.column(BookMarkMedicineTable.howToUse)
                $0.column(BookMarkMedicineTable.cautionWarning)
                $0.column(BookMarkMedicineTable.caution)
                $0.column(BookMarkMedicineTable.interaction)
                $0.column(BookMarkMedicineTable.sideEffect)
                $0.column(BookMarkMedicineTable.storageMethod)
                $0.column(BookMarkMedicineTable.updateDate)
                $0.column(BookMarkMedicineTable.tagHexColorCode, defaultValue: nil)
            })

            try db.run(takenMedicineTable.create(ifNotExists: true) {
                $0.column(TakenMedicineTable.medicineTakenTime)
                $0.column(TakenMedicineTable.itemCode)
                $0.foreignKey(
                    TakenMedicineTable.itemCode,
                    references: bookMarkTable,
                    BookMarkMedicineTable.itemCode,
                    delete: .cascade
                )
            })
        } catch {
            print("[DataBaseManager] \(error)")
        }
    }
}
