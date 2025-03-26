// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit

extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return nil
        }

        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }

        var topController = window.rootViewController

        while let presentedVC = topController?.presentedViewController {
            topController = presentedVC
        }

        return topController
    }
}
