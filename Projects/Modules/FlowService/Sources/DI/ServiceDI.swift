// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import LocalService
import RemoteService

public struct ServiceDI {
    public let insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase
    public let deleteBookMarkMedicineUseCase: DeleteBookMarkMedicineUseCase
    public let fetchBookMarkMedicineListUseCase: FetchBookMarkMedicineListUseCase
    public let findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase
    public let updateBookMarkMedicineUseCase: UpdateBookMarkMedicineUseCase
    public let registerMyMedicineUseCase: RegisterMyMedicineUseCase

    public let insertTakenMedicineUseCase: InsertTakenMedicineUseCase
    public let fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase
    public let fetchMedicineRecodeUseCase: FetchMedicineRecodeUseCase

    public let searchMedicineUseCase: SearchMedicineUseCase
}

public extension ServiceDI {
    static func resolve() -> ServiceDI {
        // DataSource
        let medicineContentDataSource: MedicineContentDataSource = MedicineContentDataSourceImpl()
        let prescriptionMedicineDataSource: PrescriptionMedicineDataSource = PrescriptionMedicineDataSourceImpl()
        let bookMakrDataSource: BookMarkMedicineDataSource = BookMarkMedicineDataSourceImpl()
        let medicineTypeDataSource: MedicineTypeDataSource = MedicineTypeDataSourceImpl()
        let takenMedicineDataSource: TakenMedicineDataSource = TakenMedicineDataSourceImpl()

        // Repository
        let insertBookMarkMedicineRepositoryImpl = InsertBookMarkMedicineRepositoryImpl(
            bookMarkMedicineDataSource: bookMakrDataSource,
            medicineTypeDataSource: medicineTypeDataSource
        )
        let deleteBookMarkMedicineRepositoryImpl = DeleteBookMarkMedicineRepositoryImpl(
            dataSource: bookMakrDataSource
        )
        let fetchBookMarkMedicineListRepositoryImpl = FetchBookMarkMedicineListRepositoryImpl(
            dataSource: bookMakrDataSource
        )
        let findBookMarkMedicineRepositoryImpl = FindBookMarkMedicineRepositoryImpl(
            dataSource: bookMakrDataSource
        )
        let updateBookMarkMedicineRepositoryImpl = UpdateBookMarkMedicineRepositoryImpl(
            dataSource: bookMakrDataSource
        )
        let insertTakenMedicineRepositoryImpl = InsertTakenMedicineRepositoryImpl(
            dataBase: takenMedicineDataSource
        )
        let fetchTakenMedicineListRepositoryImpl = FetchTakenMedicineListRepositoryImpl(
            dataBase: takenMedicineDataSource
        )
        let fetchMedicineRecodeRepositoryImpl = FetchMedicineRecodeRepositoryImpl(
            dataBase: takenMedicineDataSource
        )
        let searchMedicineRepositoryImpl = SearchMedicineRepositoryImpl(
            nomalMedicinedataSource: medicineContentDataSource,
            prescriptionMedicinedataSource: prescriptionMedicineDataSource
        )

        // UseCase
        let insertBookMarkMedicineUseCaseImpl = InsertBookMarkMedicineUseCaseImpl(
            repository: insertBookMarkMedicineRepositoryImpl
        )
        let deleteBookMarkMedicineUseCaseImpl = DeleteBookMarkMedicineUseCaseImpl(
            repository: deleteBookMarkMedicineRepositoryImpl
        )
        let fetchBookMarkMedicineListUseCaseImpl = FetchBookMarkMedicineListUseCaseImpl(
            repository: fetchBookMarkMedicineListRepositoryImpl
        )
        let findBookMarkMedicineUseCaseImpl = FindBookMarkMedicineUseCaseImpl(
            repository: findBookMarkMedicineRepositoryImpl
        )
        let updateBookMarkMedicineUseCaseImpl = UpdateBookMarkMedicineUseCaseImpl(
            repository: updateBookMarkMedicineRepositoryImpl
        )
        let insertTakenMedicineUseCaseImpl = InsertTakenMedicineUseCaseImpl(
            repository: insertTakenMedicineRepositoryImpl
        )
        let fetchTakenMedicineListUseCaseImpl = FetchTakenMedicineListUseCaseImpl(
            repository: fetchTakenMedicineListRepositoryImpl
        )
        let fetchMedicineRecodeUseCaseImpl = FetchMedicineRecodeUseCaseImpl(
            repository: fetchMedicineRecodeRepositoryImpl
        )
        let searchMedicineUseCaseImpl = SearchMedicineUseCaseImpl(
            repository: searchMedicineRepositoryImpl
        )
        let registerMyMedicineUseCaseImpl = RegisterMyMedicineUseCaseImpl(
            repository: insertBookMarkMedicineRepositoryImpl
        )

        return .init(
            insertBookMarkMedicineUseCase: insertBookMarkMedicineUseCaseImpl,
            deleteBookMarkMedicineUseCase: deleteBookMarkMedicineUseCaseImpl,
            fetchBookMarkMedicineListUseCase: fetchBookMarkMedicineListUseCaseImpl,
            findBookMarkMedicineUseCase: findBookMarkMedicineUseCaseImpl,
            updateBookMarkMedicineUseCase: updateBookMarkMedicineUseCaseImpl,
            registerMyMedicineUseCase: registerMyMedicineUseCaseImpl,
            insertTakenMedicineUseCase: insertTakenMedicineUseCaseImpl,
            fetchTakenMedicineListUseCase: fetchTakenMedicineListUseCaseImpl,
            fetchMedicineRecodeUseCase: fetchMedicineRecodeUseCaseImpl,
            searchMedicineUseCase: searchMedicineUseCaseImpl
        )
    }
}
 
