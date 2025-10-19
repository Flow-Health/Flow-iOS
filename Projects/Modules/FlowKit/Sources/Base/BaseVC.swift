// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Core

import RxSwift
import RxCocoa


open class BaseVC<ViewModel: ViewModelType>: UIViewController {

    public let viewModel: ViewModel
    public let disposeBag = DisposeBag()

    public let viewDidLoadRelay = PublishRelay<Void>()
    public let viewDidAppearRelay = PublishRelay<Void>()
    public let viewWillAppearRelay = PublishRelay<Void>()

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        attridute()
        addView()
        setAutoLayout()
        viewDidLoadRelay.accept(())
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearRelay.accept(())
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearRelay.accept(())
    }

    open func addView() {}
    open func setAutoLayout() {}
    open func bind() {}
    open func attridute() {}
}
