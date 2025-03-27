import UIKit
import FlowKit
import Core
import Model

import Kingfisher
import SnapKit
import Then
import RxSwift
import RxCocoa

class MedicineDetailViewController: BaseVC<MedicineDetailViewModel> {

    private let findItemRelay = PublishRelay<String>()
    private let insetBookMarkRelay = PublishRelay<MedicineInfoEntity?>()
    private let deleteBookMarkRelay = PublishRelay<MedicineInfoEntity?>()
    private let updateBookMarkRelay = PublishRelay<MedicineInfoEntity?>()
    private var item: MedicineInfoEntity?

    private let scrollView = VScrollView(showsVerticalScrollIndicator: true)
    private let medicineImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let updateAtLabel = PaddingLableView()
    private let companyNameLabel = UILabel().then {
        $0.font = .captionC1SemiBold
        $0.textColor = .black2
    }
    private let medicineNameLabel = UILabel().then {
        $0.font = .headerH3SemiBold
        $0.textColor = .blue1
        $0.numberOfLines = 0
    }

    private let colorTagButton = ColorTagButton()
    private let medicineCodeLabel = PaddingLableView()
    private let medicineTypeLabel = PaddingLableView()
    private let bookMarkButton = BookMarkToggleButton()
    private let explainVStack = VStack(spacing: 20)
    private let efficacyExplain = ExplainFormView(title: "효능")
    private let howToUseExplain = ExplainFormView(title: "사용법")
    private let cautionWarningExplain = ExplainFormView(title: "주의사항 경고")
    private let cautionExplain = ExplainFormView(title: "주의사항")
    private let interactionExplain = ExplainFormView(title: "상호작용")
    private let sideEffectExplain = ExplainFormView(title: "부작용")
    private let storageMethodExplain = ExplainFormView(title: "보관법")
    private let customShortDescription = ExplainFormView(title: "간단한 설명")

    override func attridute() {
        navigationItem.title = "상세정보"
        navigationItem.rightBarButtonItems = [bookMarkButton, colorTagButton]
        findItemRelay.accept(item?.itemCode ?? "")
    }

    override func addView() {
        view.addSubview(scrollView)
        scrollView.contentView.addSubViews(
            medicineImageView,
            companyNameLabel,
            medicineNameLabel,
            medicineCodeLabel,
            medicineTypeLabel,
            explainVStack
        )
        medicineImageView.addSubview(updateAtLabel)
        explainVStack.addArrangedSubviews(
            customShortDescription,
            efficacyExplain,
            howToUseExplain,
            cautionWarningExplain,
            cautionExplain,
            interactionExplain,
            sideEffectExplain,
            storageMethodExplain
        )
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.contentView.snp.makeConstraints {
            $0.bottom.equalTo(explainVStack).offset(15)
        }
        updateAtLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
        medicineImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(medicineImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        medicineNameLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        medicineCodeLabel.snp.makeConstraints {
            $0.top.equalTo(medicineTypeLabel)
            $0.leading.equalTo(medicineTypeLabel.snp.trailing).offset(5)
        }
        medicineTypeLabel.snp.makeConstraints {
            $0.top.equalTo(medicineNameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        explainVStack.snp.makeConstraints {
            $0.top.equalTo(medicineCodeLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    override func bind() {
        let input = MedicineDetailViewModel.Input(
            itemCode: findItemRelay.asObservable(),
            insetBookMarkItem: insetBookMarkRelay.asObservable(),
            deleteBookMarkItem: deleteBookMarkRelay.asObservable(),
            updateBookMarkItem: updateBookMarkRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.isBookMarked.asObservable()
            .do(onNext: { [weak self] in
                self?.colorTagButton.isHidden = !$0
                guard let item = self?.item, !$0 else { return }
                let noColorItem = MedicineInfoEntity(
                    imageURL: item.imageURL,
                    medicineName: item.medicineName,
                    companyName: item.companyName,
                    itemCode: item.itemCode,
                    efficacy: item.efficacy,
                    howToUse: item.howToUse,
                    cautionWarning: item.cautionWarning,
                    caution: item.caution,
                    interaction: item.interaction,
                    sideEffect: item.sideEffect,
                    storageMethod: item.storageMethod,
                    updateDate: item.updateDate,
                    medicineType: item.medicineType
                )
                self?.item = noColorItem
            })
            .bind(to: bookMarkButton.rx.isBookMarked)
            .disposed(by: disposeBag)

        output.tagColorHexCode.asObservable()
            .map {
                guard let hexCode = $0 else { return nil }
                return UIColor(hex: hexCode)
            }
            .bind(to: colorTagButton.rx.tagColor)
            .disposed(by: disposeBag)

        bookMarkButton.rx.tap
            .map { self.item }
            .subscribe(onNext: { [weak self] item in
                guard let self else { return }
                bookMarkButton.isBookMarked ?
                deleteBookMarkRelay.accept(item) :
                insetBookMarkRelay.accept(item)
            })
            .disposed(by: disposeBag)

        colorTagButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.presentColorPicker() })
            .disposed(by: disposeBag)
    }
}

extension MedicineDetailViewController {
    func setUp(with entity: MedicineInfoEntity) {
        medicineImageView.kf.setImage(
            with: URL(string: entity.imageURL),
            placeholder: FlowKitAsset.defaultImage.image
        )
        companyNameLabel.text = entity.companyName
        medicineNameLabel.text = entity.medicineName

        efficacyExplain.explain = entity.efficacy
        howToUseExplain.explain = entity.howToUse
        cautionWarningExplain.explain = entity.cautionWarning
        cautionExplain.explain = entity.caution
        interactionExplain.explain = entity.interaction
        sideEffectExplain.explain = entity.sideEffect
        storageMethodExplain.explain = entity.storageMethod
        customShortDescription.explain = entity.howToUse

        updateAtLabel.contentText = "마지막 업데이트: \(entity.updateDate)"
        medicineCodeLabel.contentText = entity.itemCode
        medicineTypeLabel.contentText = entity.medicineType.toString
        item = entity

        // 약 타입별 TagType
        let tagTypeMapper: [MedicineTypeEnum: TagType] = [
            .NOMAL: .Common,
            .PRESCRIPTION: .Primary,
            .CUSTOM: .Secondary
        ]
        medicineTypeLabel.setTagType(tagType: tagTypeMapper[entity.medicineType] ?? .Common)

        // 내가 설정한 약일 때,
        customShortDescription.isHidden = entity.medicineType != .CUSTOM
        [
            efficacyExplain,
            howToUseExplain,
            cautionWarningExplain,
            cautionExplain,
            interactionExplain,
            sideEffectExplain,
            storageMethodExplain,
            medicineCodeLabel
        ].forEach { $0.isHidden = entity.medicineType == .CUSTOM }
    }
}

extension MedicineDetailViewController {
    
    private func presentColorPicker() {
        guard let item else { return }
        let presentview = FlowColorPicker(
            selectedColor: PickerColor(rawValue: item.tagHexColorCode ?? ""),
            complition: pickerColorHandler
        )
        present(presentview, animated: false)
    }

    func pickerColorHandler(_ selectColor: PickerColor?) {
        guard let item else { return }
        let changedEntity: MedicineInfoEntity = .init(
            imageURL: item.imageURL,
            medicineName: item.medicineName,
            companyName: item.companyName,
            itemCode: item.itemCode,
            efficacy: item.efficacy,
            howToUse: item.howToUse,
            cautionWarning: item.cautionWarning,
            caution: item.caution,
            interaction: item.interaction,
            sideEffect: item.sideEffect,
            storageMethod: item.storageMethod,
            updateDate: item.updateDate,
            tagHexColorCode: selectColor?.hexCode,
            medicineType: item.medicineType
        )
        self.item = changedEntity
        colorTagButton.tagColor = UIColor(hex: selectColor?.hexCode)
        updateBookMarkRelay.accept(changedEntity)
    }
}
