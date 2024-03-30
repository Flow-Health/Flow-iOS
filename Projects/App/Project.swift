import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FlowApp",
    organizationName: flowOrganizationName,
    targets: [
        .target(
            name: "FlowApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(flowOrganizationName).flowApp",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: uiKitPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(
                    target: "ThirdPartyLib",
                    path: .relativeToRoot("Projects/Modules/ThirdPartyLib"),
                    condition: .none
                ),
                .target(name: "FlowWidgetExtension", condition: .none)
            ]
        ),
        .target(
            name: "FlowWidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(flowOrganizationName).flowApp.flowWidgetExtension",
            infoPlist: .extendingDefault(with: widgetPlist),
            sources: ["Widget/Sources/**"],
            resources: ["Widget/Resources/**"],
            dependencies: [
                .project(
                    target: "ThirdPartyLib",
                    path: .relativeToRoot("Projects/Modules/ThirdPartyLib"),
                    condition: .none
                )
            ]
        )
    ]
)
