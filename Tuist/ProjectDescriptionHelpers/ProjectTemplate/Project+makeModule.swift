import ProjectDescription

public extension Project {
    static func makeModule(
        name: String,
        product: Product = .framework,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency]
    ) -> Project {

        let target: Target = .target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: "\(flowOrganizationName).\(name)",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: resources,
            dependencies: dependencies
        )

        return .init(
            name: name,
            organizationName: flowOrganizationName,
            targets: [target]
        )
    }
}
