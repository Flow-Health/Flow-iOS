import ProjectDescription

public extension Project {
    static func makeModule(
        name: String,
        product: Product = .framework,
        isTestAble: Bool = false,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency]
    ) -> Project {
        return .init(
            name: name,
            organizationName: flowOrganizationName,
            targets: makeTarget(
                name: name,
                product: product,
                isTestAble: isTestAble,
                resources: resources,
                dependencies: dependencies
            ),
            fileHeaderTemplate: "___COPYRIGHT___"
        )
    }

    private static func makeTarget(
        name: String,
        product: Product = .framework,
        isTestAble: Bool = false,
        resources: ResourceFileElements?,
        dependencies: [TargetDependency]
    ) -> [Target] {
        var targets: [Target] = []
        targets.append(.target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: "\(flowOrganizationName).\(name)",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: resources,
            dependencies: dependencies
        ))
        guard isTestAble else { return targets }
        targets.append(.target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(flowOrganizationName).\(name)UnitTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["\(name)Tests/**"],
            dependencies: [.target(name: name, condition: .none)]
        ))
        return targets
    }
}
