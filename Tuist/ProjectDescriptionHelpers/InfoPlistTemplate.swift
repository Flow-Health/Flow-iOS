import ProjectDescription

// MARK: - UIkit의 Delegate를 사용하기 위한 설정
public let uiKitPlist: [String: Plist.Value] = [
    "UIUserInterfaceStyle": "Light",
    "UILaunchStoryboardName": "LaunchScreen.storyboard",
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
    ],
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
            ]
        ]
    ]
]

// MARK: - WidgetExtension을 사용하기 위한 설정
public let widgetPlist: [String: Plist.Value] = [
    "NSExtension" : [
        "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
    ]
]
