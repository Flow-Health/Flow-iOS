// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import RxSwift
import RxCocoa

class ReceiptOcrResultViewController: BaseVC<ReceiptOcrResultViewModel> {

    private var ocrResult: [MedicineInfoEntity]

    private let subTitle = UILabel().then {
        $0.customLabel("약 선택", font: .bodyB2SemiBold, textColor: .blue1)
    }

    private let mainTitle = UILabel().then {
        $0.customLabel("추가할 약을 선택하세요.", font: .headerH2SemiBold)
    }

    private let ocrMedicineSelectionTableView = UITableView().then {
        $0.rowHeight = 74
        $0.separatorStyle = .none
        $0.separatorColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(OcrMedicineSelectionCell.self, forCellReuseIdentifier: OcrMedicineSelectionCell.identifier)
    }

    private let addButton = FlowNextButton(title: "약 추가하기")

    private let retakeButton = FlowPaddingButton(buttonTitle: "다시 촬영하기")

    override func attridute() {
        navigationItem.hidesBackButton = true
    }

    init(viewModel: ReceiptOcrResultViewModel, ocrResult: [MedicineInfoEntity]) {
        self.ocrResult = ocrResult
        super.init(viewModel: viewModel)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {
        let input = ReceiptOcrResultViewModel.Input(
            setOcrResult: Observable.just(ocrResult),
            tapOcrSelectionCell: ocrMedicineSelectionTableView.rx.itemSelected.asObservable(),
            tapAddButton: addButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.ocrSelectionData
            .drive(ocrMedicineSelectionTableView.rx.items(
                cellIdentifier: OcrMedicineSelectionCell.identifier,
                cellType: OcrMedicineSelectionCell.self
            )) { index, data, cell in
                cell.setup(data.entity, isSelect: data.isSelect, isAlreadyAdd: data.isAlreadyAdd)
            }
            .disposed(by: disposeBag)

        output.isAbleToNext
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)

        retakeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubViews(
            subTitle,
            mainTitle,
            ocrMedicineSelectionTableView,
            retakeButton,
            addButton
        )
    }

    override func setAutoLayout() {
        subTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        mainTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitle.snp.bottom).offset(6)
        }

        ocrMedicineSelectionTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(mainTitle.snp.bottom).offset(50)
            $0.bottom.equalTo(retakeButton.snp.top).offset(-10)
        }

        addButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }

        retakeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(addButton.snp.top).offset(-20)
        }
    }
}
