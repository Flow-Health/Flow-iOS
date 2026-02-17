// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import SnapKit

public class BaseNavigationController: UINavigationController {
    private let backButtonImage: UIImage? = {
        if #available(iOS 26.0, *) {
            return FlowKitAsset.backArrow.image
        } else {
            return FlowKitAsset.backArrow.image.withAlignmentRectInsets(.init(top: 0.0, left: -10.0, bottom: 0.0, right: 0.0))
        }
    }()

    private var backButtonAppearance: UIBarButtonItemAppearance = {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        return backButtonAppearance
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        settingController()
    }

    private func settingController() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance
        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil
        navigationBar.standardAppearance = appearance
        navigationBar.tintColor = .black
    }
}
