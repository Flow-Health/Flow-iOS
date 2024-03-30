import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    static let Moya = TargetDependency.external(name: "Moya", condition: .none)
    static let RxSwift = TargetDependency.external(name: "RxSwift", condition: .none)
    static let SnapKit = TargetDependency.external(name: "SnapKit", condition: .none)
    static let Then = TargetDependency.external(name: "Then", condition: .none)
    static let RxCocoa = TargetDependency.external(name: "RxCocoa", condition: .none)
    static let RxMoya = TargetDependency.external(name: "RxMoya", condition: .none)
    static let KeychainSwift = TargetDependency.external(name: "KeychainSwift", condition: .none)
    static let RxFlow = TargetDependency.external(name: "RxFlow", condition: .none)
    static let Kingfisher = TargetDependency.external(name: "Kingfisher", condition: .none)
}
