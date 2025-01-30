import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FlowApp",
    organizationName: flowOrganizationName,
    options: .options(defaultKnownRegions: ["ko"], developmentRegion: "ko"),
    settings: .settings(
        base: .codeSign,
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    targets: [
        .target(
            name: "FlowApp",
            destinations: [.iPhone],
            product: .app,
            bundleId: "\(flowOrganizationName).flow-application",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: "SupportingFiles/Info.plist"),
            sources: [
                "Sources/**",
                "Intent/Sources/**"
            ],
            resources: .resources(
                ["Resources/**"],
                privacyManifest: .privacyManifest(
                    tracking: false,
                    trackingDomains: [],
                    collectedDataTypes: [],
                    accessedApiTypes: []
                )
            ),
            entitlements: .file(path: "SupportingFiles/FlowApp.entitlements"),
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
            bundleId: "\(flowOrganizationName).flow-application.flowWidget-Extension",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: widgetPlist),
            sources: [
                "Widget/Sources/**",
                "Intent/Sources/**"
            ],
            entitlements: .file(path: "Widget/Entitlements/FlowWidgetExtension.entitlements"),
            dependencies: [
                .Module.flowKit,
                .Module.flowService
            ]
        )
    ],
    fileHeaderTemplate: "___COPYRIGHT___"
)
