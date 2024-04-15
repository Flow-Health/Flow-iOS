// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

class SearchBarController: UISearchController {

    init() {
        super.init(searchResultsController: nil)
        searchBar.placeholder = "약명을 입력해보세요"
        searchBar.tintColor = .blue2
        searchBar.searchTextField.font = .bodyB1Medium
        hidesNavigationBarDuringPresentation = false
        automaticallyShowsCancelButton = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
