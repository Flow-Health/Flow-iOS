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
            sources: [
                "Sources/**",
                "Intent/Sources/**"
            ],
            resources: ["Resources/**"],
            dependencies: [
                .Module.flowKit,
                .Module.flowService,
                .target(name: "FlowWidgetExtension", condition: .none)
            ]
        ),
        .target(
            name: "FlowWidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(flowOrganizationName).flowApp.flowWidgetExtension",
            infoPlist: .extendingDefault(with: widgetPlist),
            sources: [
                "Widget/Sources/**",
                "Intent/Sources/**"
            ],
            dependencies: [
                .Module.flowKit,
                .Module.flowService
            ]
        )
    ],
    fileHeaderTemplate: "___COPYRIGHT___"
)
