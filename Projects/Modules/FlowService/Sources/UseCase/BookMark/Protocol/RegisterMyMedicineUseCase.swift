// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit

import Model
import RxSwift

public protocol RegisterMyMedicineUseCase {
    var repository: InsertBookMarkMedicineRepository { get set }

    func execute(name: String, description: String, image: UIImage?) -> Completable
}
