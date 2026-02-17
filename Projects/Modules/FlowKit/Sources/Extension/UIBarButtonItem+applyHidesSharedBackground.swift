// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit

extension UIBarButtonItem {

    
    /// iOS 26 에서의 UIBarButtonItem 리퀴드 글래스 배경을 제거하기 위한 함수
    /// - Returns: UIBarButtonItem
    @discardableResult
    public func applyHidesSharedBackground() -> Self {
        if #available(iOS 26.0, *) {
            self.hidesSharedBackground = true
        }
        return self
    }
}

