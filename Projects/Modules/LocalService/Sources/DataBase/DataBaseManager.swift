// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import SQLite
import Model

protocol DataBaseTable {
    typealias SQLiteExpression = SQLite.Expression

    static var table: Table { get set }
}

// MARK: - SQLite Table Struct

// 북마크 체크된 약 정보 테이블
struct BookMarkMedicineTable: DataBaseTable {
    static var table = Table("book_mark_medicine")

    static let itemCode = SQLiteExpression<String>("itemCode")
    static let imageURL = SQLiteExpression<String>("imageURL")
    static let medicineName = SQLiteExpression<String>("medicineName")
    static let companyName = SQLiteExpression<String>("companyName")
    static let efficacy = SQLiteExpression<String>("efficacy")
    static let howToUse = SQLiteExpression<String>("howToUse")
    static let cautionWarning = SQLiteExpression<String>("cautionWarning")
    static let caution = SQLiteExpression<String>("caution")
    static let interaction = SQLiteExpression<String>("interaction")
    static let sideEffect = SQLiteExpression<String>("sideEffect")
    static let storageMethod = SQLiteExpression<String>("storageMethod")
    static let updateDate = SQLiteExpression<String>("updateDate")
    static let tagHexColorCode = SQLiteExpression<String?>("tagHexColorCode")
}

// 복용 기록한 약 복용시간 정보 테이블
struct TakenMedicineTable: DataBaseTable {
    static var table = Table("taken_medicine")

    static let medicineTakenTime =  SQLiteExpression<Date>("medicineTakenTime")
    static let itemCode = SQLiteExpression<String>("medicineCode")
}

// 약 종류 정보 테이블 (일반약, 전문약)
struct MedicineTypeTable: DataBaseTable {
    static var table = Table("medicine_type")

    static let itemCode = SQLiteExpression<String>("medicineCode")
    static let medicineType = SQLiteExpression<String>("medicineType")
}

final class DataBaseManager {
    static let shared = DataBaseManager()
    private(set) var db: Connection?

    private init() {
        do {
            // Application Grounp에서의 SQlite 파일 경로 주소 생성
            let fileSystem = FileManager.default
            guard let fileURL = fileSystem.containerURL(forSecurityApplicationGroupIdentifier: "group.com.flow-health.flow-App")?
                .appending(path: "SQlite", directoryHint: .isDirectory) else {
                fatalError("fail to fileURL")
            }
            
            // SQlite 폴더 생성
            try? fileSystem.createDirectory(at: fileURL, withIntermediateDirectories: false)

            // 경로에 db.sqlite3 추가 (.../SQLite/db.sqlite3)
            let dbURL = fileURL.appending(path: "db.sqlite3")

            // 해당 db.sqlite3 파일 불러오기
            db = try Connection(dbURL.absoluteString)
            guard let db else { fatalError("fail to connect DataBase.") }
            debugPrint("[succes connet DB] Path: \(dbURL.absoluteString)")

            // 외래키 설정 활성화
            try db.run("PRAGMA foreign_keys = ON;")

            let bookMarkTable = BookMarkMedicineTable.table
            let takenMedicineTable = TakenMedicineTable.table
            let medicineTypeTable = MedicineTypeTable.table

            // 테이블이 없다면, 테이블 생성
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

            try db.run(medicineTypeTable.create(ifNotExists: true) {
                $0.column(MedicineTypeTable.itemCode)
                $0.column(MedicineTypeTable.medicineType)
                $0.foreignKey(
                    MedicineTypeTable.itemCode,
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
