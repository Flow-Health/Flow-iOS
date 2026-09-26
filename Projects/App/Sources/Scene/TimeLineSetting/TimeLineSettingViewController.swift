// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Core
import Model

import SnapKit
import Then
import RxSwift
import RxCocoa

class TimeLineSettingViewController: BaseVC<TimeLineSettingViewModel> {

    private let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    private let deleteRowIDsRelay = PublishRelay<[Int64]>()
    private let selectedCountRelay = BehaviorRelay<Int>(value: 0)

    private enum SettingListSection {
        case takenMedicine
    }

    private struct SettingListItem: Hashable {
        let rowID: Int64
        let takenTime: String?
        let medicineName: String?
        let companyName: String?
        let imageURL: String
    }

    private let dateLabel = UILabel().then {
        $0.customLabel(font: .headerH2SemiBold, textColor: .black)
    }
    private let descriptionLabel = UILabel().then {
        $0.customLabel(
            "삭제할 복약 기록을 선택해 주세요",
            font: .bodyB2Medium,
            textColor: .black2
        )
    }
    private let selectAllButton = UIBarButtonItem(
        title: "전체 선택",
        style: .plain,
        target: nil,
        action: nil
    )
    private lazy var settingCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsMultipleSelection = true
        $0.contentInset = .init(top: 0, left: 0, bottom: 90, right: 0)
    }
    private lazy var settingDataSource = makeListDataSource()

    private let emptyView = EmptyStatusView(
        icon: FlowKitAsset.pageWithCloud.image,
        title: "기록된 정보가 없습니다",
        subTitle: "해당 날짜에 삭제할\n복약 기록이 없어요"
    )
    private let deleteButton = FlowNextButton(title: "삭제").then {
        $0.isEnabled = false
    }

    func setUp(date: Date) {
        selectedDateRelay.accept(date)
    }

    private func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(84)
        ))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(84)
            ),
            subitems: [item]
        )
        group.contentInsets = .init(top: 0, leading: 22, bottom: 0, trailing: 22)
        return .init(section: NSCollectionLayoutSection(group: group))
    }

    private func makeListDataSource() -> UICollectionViewDiffableDataSource<SettingListSection, SettingListItem> {
        let cellRegistration = UICollectionView.CellRegistration<TimeLineSettingCell, SettingListItem> { cell, _, item in
            cell.configCell(
                takenTime: item.takenTime,
                medicineName: item.medicineName,
                companyName: item.companyName,
                imageURL: item.imageURL
            )
        }

        let dataSource = UICollectionViewDiffableDataSource<SettingListSection, SettingListItem>(
            collectionView: settingCollectionView
        ) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<SettingListSection, SettingListItem>()
        snapshot.appendSections([.takenMedicine])
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }

    private func updateList(to entities: [MedicineTakenEntity]) {
        let items: [SettingListItem] = entities.map {
            .init(
                rowID: $0.rowID,
                takenTime: $0.takenTime.toString(.nomal),
                medicineName: $0.medicineInfo.medicineName,
                companyName: $0.medicineInfo.companyName,
                imageURL: $0.medicineInfo.imageURL
            )
        }

        var snapshot = NSDiffableDataSourceSnapshot<SettingListSection, SettingListItem>()
        snapshot.appendSections([.takenMedicine])
        snapshot.appendItems(items, toSection: .takenMedicine)
        settingDataSource.apply(snapshot, animatingDifferences: true)

        selectedCountRelay.accept(0)
        selectAllButton.isEnabled = !items.isEmpty
    }

    private var selectedRowIDs: [Int64] {
        (settingCollectionView.indexPathsForSelectedItems ?? [])
            .compactMap { settingDataSource.itemIdentifier(for: $0)?.rowID }
    }

    private func updateSelectedCount() {
        selectedCountRelay.accept(settingCollectionView.indexPathsForSelectedItems?.count ?? 0)
    }

    private func toggleSelectAll() {
        let allIndexPaths = settingDataSource.snapshot().itemIdentifiers
            .compactMap { settingDataSource.indexPath(for: $0) }
        let isAllSelected = (settingCollectionView.indexPathsForSelectedItems?.count ?? 0) == allIndexPaths.count

        allIndexPaths.forEach {
            if isAllSelected {
                settingCollectionView.deselectItem(at: $0, animated: false)
            } else {
                settingCollectionView.selectItem(at: $0, animated: false, scrollPosition: [])
            }
        }
        updateSelectedCount()
    }

    private func presentDeleteAlert(count: Int) {
        let alert = UIAlertController(
            title: "선택한 \(count)개의 기록을 삭제할까요?",
            message: "삭제한 복약 기록은 되돌릴 수 없습니다",
            preferredStyle: .alert
        )
        [
            UIAlertAction(title: "아니요", style: .default),
            UIAlertAction(title: "네, 삭제합니다", style: .destructive) { [weak self] _ in
                guard let self else { return }
                deleteRowIDsRelay.accept(selectedRowIDs)
            }
        ].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

    override func attribute() {
        navigationItem.title = "타임라인 관리"
        navigationItem.rightBarButtonItem = selectAllButton
        view.backgroundColor = .white
    }

    override func addView() {
        view.addSubViews(
            dateLabel,
            descriptionLabel,
            settingCollectionView,
            deleteButton
        )
        settingCollectionView.addSubview(emptyView)
    }

    override func setAutoLayout() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
        settingCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }
        deleteButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    override func bind() {
        let input = TimeLineSettingViewModel.Input(
            selectedDate: selectedDateRelay.asObservable(),
            deleteRowIDs: deleteRowIDsRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        selectedDateRelay
            .map { $0.toString(.mounthAndDateWithCharacter) + "의 복약 기록" }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        output.takenMedicineData
            .drive(with: self) { owner, data in
                owner.updateList(to: data)
            }
            .disposed(by: disposeBag)

        output.isHiddenEmptyView
            .distinctUntilChanged()
            .drive(with: self) { owner, isHidden in
                owner.emptyView.alpha = isHidden ? 0 : 1
            }
            .disposed(by: disposeBag)

        output.deleteCompleted
            .emit(with: self) { owner, count in
                owner.presentDeleteCompletedToast(count: count)
            }
            .disposed(by: disposeBag)

        selectedCountRelay
            .bind(with: self) { owner, count in
                owner.deleteButton.isEnabled = count > 0
                owner.deleteButton.setTitle(count > 0 ? "\(count)개 삭제" : "삭제", for: .normal)
                owner.selectAllButton.title = owner.isAllSelected ? "선택 해제" : "전체 선택"
            }
            .disposed(by: disposeBag)

        Observable.merge(
            settingCollectionView.rx.itemSelected.map { _ in () },
            settingCollectionView.rx.itemDeselected.map { _ in () }
        )
        .bind(with: self) { owner, _ in
            owner.updateSelectedCount()
        }
        .disposed(by: disposeBag)

        selectAllButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.toggleSelectAll()
            }
            .disposed(by: disposeBag)

        deleteButton.rx.tap
            .withLatestFrom(selectedCountRelay)
            .filter { $0 > 0 }
            .bind(with: self) { owner, count in
                owner.presentDeleteAlert(count: count)
            }
            .disposed(by: disposeBag)
    }

    private var isAllSelected: Bool {
        let total = settingDataSource.snapshot().numberOfItems
        let selected = settingCollectionView.indexPathsForSelectedItems?.count ?? 0
        return total > 0 && total == selected
    }

    private func presentDeleteCompletedToast(count: Int) {
        let alert = UIAlertController(
            title: nil,
            message: "\(count)개의 복약 기록을 삭제했습니다",
            preferredStyle: .alert
        )
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            alert.dismiss(animated: true)
        }
    }
}
