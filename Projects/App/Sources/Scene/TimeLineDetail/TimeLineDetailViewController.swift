import UIKit
import FlowKit
import Core
import Model

import SnapKit
import Then
import RxGesture
import RxSwift
import RxCocoa

class TimeLineDetailViewController: BaseVC<TimeLineDetailViewModel> {

    private let selectedDateRelay = BehaviorRelay<Date>(value: Date())
    private let medicineCountRelay = BehaviorRelay<Int>(value: 0)
    private let openTimeLineSetting = PublishRelay<Date>()

    private let refreshControl = UIRefreshControl()

    private enum TimeLineListSection {
        case timeLine
    }

    private struct TimeLineListItem: Hashable {
        let rowID: Int64
        let isLast: Bool
        let takenTime: String?
        let medicineName: String?
        let companyName: String?
        let imageURL: String
    }

    private lazy var timeLineCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
    }
    private var timeLineDataSource: UICollectionViewDiffableDataSource<TimeLineListSection, TimeLineListItem>?
    
    private let timeLineEmptyView = EmptyStatusView(
        icon: FlowKitAsset.pageWithCloud.image,
        title: "기록된 정보가 없습니다",
        subTitle: "복용한 약을 기록하여\n타임라인을 만들어 보세요"
    )

    private func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(90)
        ))

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(90)
            ),
            subitems: [item]
        )
        group.contentInsets = .init(top: 0, leading: 22, bottom: 0, trailing: 22)

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(69)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]

        return .init(section: section)
    }

    private func settingListDataSource() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<TimeLineListHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] header, _, _ in
            guard let self else { return }
            self.bindHeader(header)
        }

        let cellRegistration = UICollectionView.CellRegistration<TimeLineListCell, TimeLineListItem> { cell, indexPath, itemIdentifier in
            cell.configCell(
                isLast: itemIdentifier.isLast,
                takenTime: itemIdentifier.takenTime,
                medicineName: itemIdentifier.medicineName,
                companyName: itemIdentifier.companyName,
                imageURL: itemIdentifier.imageURL
            )
        }

        timeLineDataSource = .init(collectionView: timeLineCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })

        timeLineDataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            guard elementKind == UICollectionView.elementKindSectionHeader else { return nil }
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        var snapshot = NSDiffableDataSourceSnapshot<TimeLineListSection, TimeLineListItem>()
        snapshot.appendSections([.timeLine])
        timeLineDataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func bindHeader(_ header: TimeLineListHeaderView) {
        medicineCountRelay
            .observe(on: MainScheduler.instance)
            .bind(to: header.countBinder)
            .disposed(by: header.disposeBag)

        header.configure(dateRelay: selectedDateRelay)
    }

    private func updateList(to entities: [MedicineTakenEntity]) {
        guard let timeLineDataSource else { return }
        
        let items: [TimeLineListItem] = entities.enumerated().map { (offset, entity) in
            .init(
                rowID: entity.rowID,
                isLast: offset == entities.count - 1,
                takenTime: entity.takenTime.toString(.nomal),
                medicineName: entity.medicineInfo.medicineName,
                companyName: entity.medicineInfo.companyName,
                imageURL: entity.medicineInfo.imageURL
            )
        }

        var snapshot = NSDiffableDataSourceSnapshot<TimeLineListSection, TimeLineListItem>()
        snapshot.appendSections([.timeLine])
        snapshot.appendItems(items, toSection: .timeLine)
        timeLineDataSource.apply(snapshot, animatingDifferences: true)

        medicineCountRelay.accept(items.count)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedDateRelay.accept(selectedDateRelay.value)
        if #available(iOS 26.0, *) {
            navigationController?.interactiveContentPopGestureRecognizer?.isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 26.0, *) {
            navigationController?.interactiveContentPopGestureRecognizer?.isEnabled = true
        }
    }

    override func attribute() {
        navigationItem.title = "타임라인"
        view.backgroundColor = .white
        let barButtonMenu: UIMenu = UIMenu(title: "", children: [
            UIAction(title: "타임라인 관리", handler: { [weak self] _ in
                guard let self else { return }
                openTimeLineSetting.accept(selectedDateRelay.value)
            })
        ])
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "list.bullet"), menu: barButtonMenu)
        timeLineCollectionView.refreshControl = refreshControl
        settingListDataSource()
    }

    override func addView() {
        view.addSubview(timeLineCollectionView)
        timeLineCollectionView.addSubview(timeLineEmptyView)
    }

    override func setAutoLayout() {
        timeLineCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        timeLineEmptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
        }
    }

    override func bind() {
        let input = TimeLineDetailViewModel.Input(
            selectedDate: selectedDateRelay.asObservable(),
            openTimeLineSetting: openTimeLineSetting.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.takenMedicineData
            .drive(
                with: self,
                onNext: { owner, data in
                    owner.updateList(to: data)
                }
            )
            .disposed(by: disposeBag)

        output.isHiddenEmptyView
            .distinctUntilChanged()
            .drive(onNext: { isHidden in
                if isHidden {
                    self.timeLineEmptyView.alpha = 0
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.timeLineEmptyView.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let currentDate = owner.selectedDateRelay.value
                owner.selectedDateRelay.accept(currentDate)
                owner.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)

        view.rx.swipeGesture([.right, .left])
            .skip(2)
            .map { [weak self] gesture in
                guard let self else { return Date() }
                let currentSelectDate = self.selectedDateRelay.value
                let addDate = gesture.direction == .right ? -1 : 1
                return Calendar.current.date(byAdding: .day, value: addDate, to: currentSelectDate)!
            }
            .filter {
                let overDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                return $0.toString(.fullDate) != overDate.toString(.fullDate)
            }
            .bind(to: selectedDateRelay)
            .disposed(by: disposeBag)
    }
}
