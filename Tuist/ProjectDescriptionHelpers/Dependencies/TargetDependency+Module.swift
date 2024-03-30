import ProjectDescription

public extension TargetDependency {
    struct Module {}
}

public extension TargetDependency.Module {
    static let flowKit = module(name: "FlowKit")
    static let flowService = module(name: "FlowService")
    static let localService = module(name: "LocalService")
    static let remoteService = module(name: "RemoteService")
    static let model = module(name: "Model")
    static let core = module(name: "Core")
    static let thirdPartyLib = module(name: "ThirdPartyLib")

    private static func module(name: String) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToRoot("Projects/Modules/\(name)"),
            condition: .none
        )
    }
}
