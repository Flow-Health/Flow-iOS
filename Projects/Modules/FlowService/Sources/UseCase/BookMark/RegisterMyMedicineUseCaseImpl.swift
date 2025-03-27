// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit

import Model
import RxSwift

class RegisterMyMedicineUseCaseImpl: RegisterMyMedicineUseCase {
    var repository: InsertBookMarkMedicineRepository

    public init(repository: InsertBookMarkMedicineRepository) {
        self.repository = repository
    }

    func execute(name: String, description: String, image: UIImage?) -> Completable {

        // 기록할 약의 고유 UUID 생성
        let myMedicineID = UUID().uuidString

        // 이미지 저장 및 해당 이미지 경로 imageFileUrl에 저장
        let imageFileUrl: String = saveImage(imageID: myMedicineID, with: image)

        return repository.insertBookMarkMedicine(with: .init(
            imageURL: imageFileUrl,
            medicineName: name,
            companyName: "내가 만든 약",
            itemCode: myMedicineID,
            efficacy: "",
            howToUse: description,
            cautionWarning: "",
            caution: "",
            interaction: "",
            sideEffect: "",
            storageMethod: "",
            updateDate: Date().toString(.fullDate),
            medicineType: .CUSTOM
        ))
    }
}

extension RegisterMyMedicineUseCaseImpl {
    private func saveImage(imageID: String, with image: UIImage?) -> String {
        
        guard let imageData = image?.jpegData(compressionQuality: 0.1) else { return "" }

        let fileSystem = FileManager.default
        guard let fileURL = fileSystem.containerURL(forSecurityApplicationGroupIdentifier: "group.com.flow-health.flow-App")?
            .appending(path: "MyMedicineImages", directoryHint: .isDirectory) else {
            fatalError("fail to fileURL")
        }
        let imageFileUrl = fileURL.appending(path: "\(imageID).jpeg")

        do {
            try? fileSystem.createDirectory(at: fileURL, withIntermediateDirectories: false)
            try imageData.write(to: imageFileUrl)
        } catch {
            debugPrint("[\(#file) \(error)]")
            return ""
        }

        return imageFileUrl.absoluteString
    }
}
