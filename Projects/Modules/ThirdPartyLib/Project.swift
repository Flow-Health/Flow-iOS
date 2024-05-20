import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "ThirdPartyLib",
    settings: .settings(base: .codeSign),
    targets: [
        .target(
            name: "ThirdPartyLib",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(flowOrganizationName).ThirdPartyLib",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            dependencies: [
                .SPM.Moya,
                .SPM.RxMoya,
                .SPM.RxSwift,
                .SPM.SnapKit,
                .SPM.Then,
                .SPM.RxCocoa,
                .SPM.RxFlow,
                .SPM.RxGesture,
                .SPM.KeychainSwift,
                .SPM.Kingfisher,
                .SPM.SQLite
            ]
        )
    ]
)
