import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

enum AppInfoType: String, CaseIterable {

    case inquiry = "문의하기"
    case introduction = "서비스 소개"

    enum InteractionType {
        case withURL(url: String)
        case withNavigate(step: FlowStep)
    }

    var interactionType: InteractionType {
        switch self {
        case .inquiry: 
            return .withURL(url: "mailto:bjcho1503@naver.com")
        case .introduction:
            return .withURL(url: "https://flow-application.notion.site/Flow-6adca28f25e549a7958ef0906b74bd8d?pvs=4")
        }
    }
}

class AppInfoViewController: BaseVC<AppInfoViewModel> {
    private let appInfoTableView = UITableView().then {
        $0.bounces = false
        $0.separatorStyle = .none
        $0.rowHeight = 50
        $0.register(AppInfoTableViewCell.self, forCellReuseIdentifier: AppInfoTableViewCell.identifier)
    }
    private let versionLabel = UILabel().then {
        $0.customLabel(
            "앱 버전: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)",
            font: .captionC1Medium,
            textColor: .black2
        )
    }

    override func attridute() {
        navigationItem.title = "앱 정보"
    }

    override func addView() {
        view.addSubViews(
            appInfoTableView,
            versionLabel
        )
    }

    override func setLayout() {
        appInfoTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(appInfoTableView.contentSize.height)
        }
        versionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(appInfoTableView.snp.bottom).offset(12)
        }
    }

    override func bind() {
        let input = AppInfoViewModel.Input(
            appInfoIndexPath: appInfoTableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.openURL
            .filter { UIApplication.shared.canOpenURL($0) }
            .emit(onNext: { UIApplication.shared.open($0) })
            .disposed(by: disposeBag)

        Observable.of(AppInfoType.allCases)
            .bind(to: appInfoTableView.rx.items(
                cellIdentifier: AppInfoTableViewCell.identifier,
                cellType: AppInfoTableViewCell.self
            )) { _, type, cell in
                cell.selectionStyle = .none
                cell.setup(title: type.rawValue)
            }
            .disposed(by: disposeBag)
    }
}
