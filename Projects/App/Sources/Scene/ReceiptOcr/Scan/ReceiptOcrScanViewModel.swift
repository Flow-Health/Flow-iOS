// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

enum OcrError: Error, LocalizedError {
    case networkError, emptyResult, toManyText, cameraSettingFailed, noAuthorization, noCaptureDevice, noSession, captureFailed, noPreview, someError(message: String)

    var errorDescription: String? {
        switch self {
        case .emptyResult:
            return "사진에서 약의 이름을 찾을 수 없습니다.\n의약품 명칭 부분을 정확하게 촬영해주세요."
        case .toManyText:
            return "너무 많은 글자가 인식되고 있습니다.\n의약품 명칭 부분을 정확하게 촬영해주세요."
        case .cameraSettingFailed:
            return "카메라 접근에 실패하였습니다."
        case .noAuthorization:
            return "설정에서 카메라를 허용으로 변경해주세요."
        case .noCaptureDevice:
            return "예상치 못한 오류가 발생하였습니다. (CaptureDevice Error)"
        case .noSession:
            return "예상치 못한 오류가 발생하였습니다. (NoSession Error)"
        case .captureFailed:
            return "사진 촬영에 실패하였습니다."
        case .noPreview:
            return "사진 촬영에 실패하였습니다. (NoPreview)"
        case .someError(let message):
            return message
        default:
            return "예상치 못한 오류가 발생하였습니다.\n(\(self))"
        }
    }

    // 단어 최대 개수
    static let textMaxCount = 10
}

class ReceiptOcrScanViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let searchMedicineWithOcrUseCase: SearchMedicineWithOcrUseCase

    struct Input {
        let ocrTextList: Observable<[String]>
        let tapScanButton: Observable<Void>
    }
    
    struct Output {
        let OcrError: Signal<OcrError>
        let isLoading: Driver<Bool>
    }

    init(searchMedicineWithOcrUseCase: SearchMedicineWithOcrUseCase) {
        self.searchMedicineWithOcrUseCase = searchMedicineWithOcrUseCase
    }

    func transform(input: Input) -> Output {
        let ocrErrorRelay = PublishRelay<OcrError>()
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)

        input.tapScanButton
            .map { true }
            .bind(to: isLoadingRelay)
            .disposed(by: disposeBag)

        input.ocrTextList
            .do(onNext: { _ in
                isLoadingRelay.accept(true)
            })
            .flatMap { ocrText -> Observable<Result<[MedicineInfoEntity], OcrError>> in
                let validText = self.toValidOcrTextList(ocrText)

                // 약 이름이 기준치 이상일 때, 에러처리
                guard validText.count <= OcrError.textMaxCount else {
                    return .just(.failure(.toManyText))
                }

                return self.searchMedicineWithOcrUseCase.execute(with: validText)
                    .flatMap { result -> Single<Result<[MedicineInfoEntity], OcrError>> in
                        // 결과 값이 없을 때, 에러 처리
                        guard result.isEmpty == false else {
                            return .just(.failure(.emptyResult))
                        }
                        return .just(.success(result))
                    }
                    .catchAndReturn(.failure(.networkError))
                    .asObservable()
            }
            .withUnretained(self)
            .subscribe(onNext: { (owner, result) in
                isLoadingRelay.accept(false)
                switch result {

                case let .success(ocrList):
                    owner.steps.accept(FlowStep.receiptOcrResultIsRequired(with: ocrList))

                case let .failure(error):
                    ocrErrorRelay.accept(error)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            OcrError: ocrErrorRelay.asSignal(),
            isLoading: isLoadingRelay.asDriver()
        )
    }

    private func toValidOcrTextList(_ texts: [String]) -> [String] {

        let unAbleString = ["•", "합니다", "습니다", "마세요", "계산서", "영수증", "공제신청", "세부내역", "부담항목", "복용", "봉투", "처방", "처방의약품", "명칭", "환자", "질병" ,"투여", "투약", "구분코드", "봉투", "약품", "값", "횟수", "일수", "총투", "여백"]

        let unAbleCharacters = ["(", ")", "[", "]", ",", "-", "+", "\\", "|"]

        // 필요없는 문장 필터링 진행
        let longStringFilterTexts = texts
            .filter { text in
                unAbleString.contains { word in text.contains(word) } == false
            }
        
        // 공백 기준으로 문장 분리
        let spliteTexts = longStringFilterTexts
            .flatMap { $0.components(separatedBy: .whitespaces).filter { $0.isEmpty == false } }

        // 기본적인 필터링 진행
        let filterTexts = spliteTexts
            .filter { $0.count > 1 } // 문장 개수가 1개 이하 제거
            .filter { $0.allSatisfy { $0.isNumber } == false } // 숫자로만 이루어저 있는 문장 제거
            .filter { $0.first!.isNumber == false } // 첫 단어가 숫자인 문장 제거

        // 특수문자 필터링 진행 및 단위 삭제
        let validTexts = filterTexts
            .filter { text in
                unAbleCharacters.contains { word in text.contains(word) } == false
            }
            .map { text in
                if let index = text.firstIndex(where: { $0.isNumber }) {
                    return String(text[..<index])
                } else {
                    return text
                }
            }
            .filter { $0.count > 1 }

        return validTexts
    }
}
