// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

extension NotificationCenter {
    public static let keyboardHightObservable = Observable.merge(
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification),
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
    )
    .map { notification -> CGFloat in
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let userInfo = notification.userInfo,
               let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                return keyboardFrame.height
            }
        }

        return 0.0
    }
}
