// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import LocalService
import RemoteService

public struct ServiceDI {
    public let insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase
    public let deleteBookMarkMedicineUseCase: DeleteBookMarkMedicineUseCase
    public let fetchBookMarkMedicineListUseCase: FetchBookMarkMedicineListUseCase
    public let findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase

    public let insertTakenMedicineUseCase: InsertTakenMedicineUseCase
    public let fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase
    public let fetchMedicineRecodeUseCase: FetchMedicineRecodeUseCase

    public let searchMedicineUseCase: SearchMedicineUseCase
}

public extension ServiceDI {
    static func resolve() -> ServiceDI {
        // DataSource
        let medicineContentDataSource: MedicineContentDataSource = MedicineContentDataSourceImpl()
        let bookMakrDataSource: BookMarkMedicineDataSource = BookMarkMedicineDataSourceImpl()
        let takenMedicineDataSource: TakenMedicineDataSource = TakenMedicineDataSourceImpl()

        // Repository
        let insertBookMarkMedicineRepository = InsertBookMarkMedicineRepositoryImpl(
            dataSource: bookMakrDataSource
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
        let insertTakenMedicineRepository = InsertTakenMedicineRepositoryImpl(
            dataBase: takenMedicineDataSource
        )
        let fetchTakenMedicineListRepository = FetchTakenMedicineListRepositoryImpl(
            dataBase: takenMedicineDataSource
        )
        let fetchMedicineRecodeRepository = FetchMedicineRecodeRepositoryImpl(
            dataBase: takenMedicineDataSource
        )
        let searchMedicineRepository = SearchMedicineRepositoryImpl(
            dataSource: medicineContentDataSource
        )

        // UseCase
        let insertBookMarkMedicineUseCaseImpl = InsertBookMarkMedicineUseCaseImpl(
            repository: insertBookMarkMedicineRepository
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
        let insertTakenMedicineUseCase = InsertTakenMedicineUseCaseImpl(
            repository: insertTakenMedicineRepository
        )
        let fetchTakenMedicineListUseCase = FetchTakenMedicineListUseCaseImpl(
            repository: fetchTakenMedicineListRepository
        )
        let fetchMedicineRecodeUseCase = FetchMedicineRecodeUseCaseImpl(
            repository: fetchMedicineRecodeRepository
        )
        let searchMedicineUseCase = SearchMedicineUseCaseImpl(
            repository: searchMedicineRepository
        )

        return .init(
            insertBookMarkMedicineUseCase: insertBookMarkMedicineUseCaseImpl,
            deleteBookMarkMedicineUseCase: deleteBookMarkMedicineUseCaseImpl,
            fetchBookMarkMedicineListUseCase: fetchBookMarkMedicineListUseCaseImpl,
            findBookMarkMedicineUseCase: findBookMarkMedicineUseCaseImpl,
            insertTakenMedicineUseCase: insertTakenMedicineUseCase,
            fetchTakenMedicineListUseCase: fetchTakenMedicineListUseCase,
            fetchMedicineRecodeUseCase: fetchMedicineRecodeUseCase,
            searchMedicineUseCase: searchMedicineUseCase
        )
    }
}
 
