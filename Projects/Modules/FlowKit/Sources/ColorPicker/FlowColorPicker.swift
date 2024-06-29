import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa
import RxGesture

public enum PickerColor: String, CaseIterable {
    case red = "FF4242"
    case orange = "FFAC0B"
    case yellow = "FFE500"
    case green = "7BE726"
    case darkGreen = "418720"
    case blue = "6096FF"
    case purple = "C668FF"

    public var hexCode: String {
        switch self {
        case .red: return "FF4242"
        case .orange: return "FFAC0B"
        case .yellow: return "FFE500"
        case .green: return "7BE726"
        case .darkGreen: return "418720"
        case .blue: return "6096FF"
        case .purple: return "C668FF"
        }
    }
}

public class FlowColorPicker: UIViewController {

    private let disposeBag: DisposeBag = .init()
    private var selectedColor: PickerColor?
    private let complition: (PickerColor?) -> Void
    private let selectedColorRelay = PublishRelay<PickerColor?>()

    private let pickerBackground = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    private let pickerTitleLabel = UILabel().then {
        $0.customLabel("태그 색상", font: .headerH3Bold, textColor: .black)
    }
    private let colorListStackView = HStack(spacing: 15).then {
        $0.alignment = .center
    }
    private let resetColorButton = FlowPaddingButton(buttonTitle: "색상 초기화")

    public init(
        selectedColor: PickerColor?,
        complition: @escaping (PickerColor?) -> Void
    ) {
        self.selectedColor = selectedColor
        self.complition = complition
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentWithAnimation()
    }

    public override func viewWillAppear(_ animated: Bool) {
        changeToggleButtonCheck(selectedColor)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        bind()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addView()
        setLayout()
    }

    private func attribute() {
        pickerBackground.transform = .init(translationX: 0, y: view.frame.height)
        PickerColor.allCases.forEach { color in
            let toggleButton = ColorPIckerToggleButton(colorType: color)

            toggleButton.rx.tap.asObservable()
                .subscribe(
                    with: self,
                    onNext: { owner, _ in
                        owner.selectedColorRelay.accept(color)
                    }
                )
                .disposed(by: disposeBag)

            colorListStackView.addArrangedSubview(toggleButton)
        }
    }

    private func addView() {
        view.addSubViews(pickerBackground)
        pickerBackground.addSubViews(
            pickerTitleLabel,
            colorListStackView,
            resetColorButton
        )
    }

    private func setLayout() {
        pickerBackground.snp.makeConstraints {
            $0.top.equalTo(pickerTitleLabel).offset(-25)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(20)
        }
        pickerTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(colorListStackView.snp.top).offset(-10)
            $0.leading.equalToSuperview().inset(25)
        }
        colorListStackView.snp.makeConstraints {
            $0.bottom.equalTo(resetColorButton.snp.top).offset(-18)
            $0.leading.equalToSuperview().inset(25)
            $0.trailing.lessThanOrEqualToSuperview().inset(25)
            $0.height.equalTo(30)
        }
        resetColorButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(25)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    private func bind() {
        selectedColorRelay
            .do(onNext: { [weak self] in self?.selectedColor = $0 })
            .subscribe(onNext: changeToggleButtonCheck(_:))
            .disposed(by: disposeBag)

        resetColorButton.rx.tap
            .map { nil }
            .bind(to: selectedColorRelay)
            .disposed(by: disposeBag)

        view.rx.tapGesture()
            .skip(1)
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in self?.dismissWithAnimation() })
            .disposed(by: disposeBag)
    }
}

extension FlowColorPicker {
    private func changeToggleButtonCheck(_ color: PickerColor?) {
        colorListStackView.arrangedSubviews
            .map { $0 as? ColorPIckerToggleButton }
            .compactMap { $0 }
            .forEach { $0.isChecked = $0.color == color }
    }

    private func presentWithAnimation() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0
        ) { [self] in
            view.backgroundColor = .black.withAlphaComponent(0.4)
            pickerBackground.transform = .identity
        }
    }

    private func dismissWithAnimation() {
        complition(selectedColor)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.1,
            animations: { [self] in
                view.layer.opacity = 0
                pickerBackground.transform = .init(translationX: 0, y: view.frame.height)
            },
            completion: { [self] _ in dismiss(animated: false) }
        )
    }
}
