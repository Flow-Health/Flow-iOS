// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import RxSwift
import SnapKit
import Then

public class VScrollView: UIScrollView {
    public let contentView = UIView().then { $0.backgroundColor = .clear }
    private let refreshController = UIRefreshControl()
    private var refreshAction: (() -> Void)?

    public init(
        showsVerticalScrollIndicator: Bool = false,
        isRefreshAble: Bool = false,
        refreshAction: @escaping () -> Void = {}
    ) {
        super.init(frame: .zero)
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        if isRefreshAble {
            self.refreshControl = refreshController
            refreshController.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
            self.refreshAction = refreshAction
        }
        contentInset = .init(top:  0, left: 0, bottom: 15, right: 0)
        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func refreshHandler() {
        guard let refreshAction else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            refreshAction()
            self.refreshController.endRefreshing()
        }
    }
}
