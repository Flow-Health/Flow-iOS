import UIKit
import FlowKit
import Core

import Kingfisher
import SnapKit
import Then
import RxSwift
import RxCocoa

class MedicineDetailViewController: BaseVC<MedicineDetailViewModel> {
    private let scrollView = VScrollView(showsVerticalScrollIndicator: true)
    private let medicineImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
    private let medicineCodeLabel = PaddingLableView()
    private let bookMarkButton = UIBarButtonItem().then {
        $0.tintColor = .blue1
        $0.image = UIImage(systemName: "bookmark.fill")
    }
    private let explainVStack = VStack(spacing: 20)
    private let efficacyExplain = ExplainFormView(title: "효능")
    private let howToUseExplain = ExplainFormView(title: "사용법")
    private let cautionWarningExplain = ExplainFormView(title: "주의사항 경고")
    private let cautionExplain = ExplainFormView(title: "주의사항")
    private let interactionExplain = ExplainFormView(title: "상호작용")
    private let sideEffectExplain = ExplainFormView(title: "부작용")
    private let storageMethodExplain = ExplainFormView(title: "보관법")

    override func attridute() {
        navigationItem.title = "상세정보"
        navigationItem.rightBarButtonItem = bookMarkButton
        mockUpSetting()
    }

    override func addView() {
        view.addSubview(scrollView)
        scrollView.contentView.addSubViews(
            medicineImageView,
            companyNameLabel,
            medicineNameLabel,
            medicineCodeLabel,
            explainVStack
        )
        medicineImageView.addSubview(updateAtLabel)
        explainVStack.addArrangedSubviews(
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
            $0.top.bottom.width.equalToSuperview()
            $0.bottom.equalTo(explainVStack).offset(15)
        }
        updateAtLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
        medicineImageView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
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
            $0.top.equalTo(medicineNameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        explainVStack.snp.makeConstraints {
            $0.top.equalTo(medicineCodeLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // TODO: - Delete Mockup
    private func mockUpSetting() {
        medicineImageView.kf.setImage(with: URL(string: "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151335245510200022"))
        companyNameLabel.text = "뉴스피린(주)"
        medicineNameLabel.text = "뉴스피린장용정100밀리그램"
        efficacyExplain.explain = "다른 비스테로이드성 소염진통제 및 살리실산 제제, 일주일 동안 메토트렉세이트 15밀리그람(15mg/주) 이상의 용량은 이 약과 병용 투여 시 출혈이 증가되거나 신기능이 감소될 수 있으므로 함께 사용하지 않습니다.\n\n항응고제, 이부프로펜, 나프록센 등 일부 비스테로이드성 소염진통제, 혈전용해제, 다른 혈소판응집억제제, 지혈제, 당뇨병치료제(인슐린제제, 톨부타미드 등), 요산배설촉진제(벤즈브로마론, 프로베네시드), 티아지드계 이뇨제, 리튬제제, 선택적 세포토닌 재흡수 억제제, 디곡신, 전신 작용 부신피질호르몬 제제(애디슨병 대체요법용 히드로코티손 제외), 안지오텐신 전환 효소 억제제, 발프로산 제제를 복용하는 사람은 의사 또는 약사와 상의하십시오.\n\n알칼리제제(예: 탄산수소나트륨, 탄산마그네슘) 또는 습기가 차기 쉬운 제제와 함께 섞지 마십시오.\n\n알코올과 병용 투여 시 위장관 점막 손상이 증가하고, 이 약과 알코올의 상승효과로 인해 출혈시간이 연장될 수 있습니다.\n"
        cautionExplain.explain = "습기를 피해 실온에서 보관하십시오.\n\n어린이의 손이 닿지 않는 곳에 보관하십시오.\n"
        updateAtLabel.contentText = "마지막 업데이트: 2024-01-11"
        medicineCodeLabel.contentText = "20010024"
    }
}
