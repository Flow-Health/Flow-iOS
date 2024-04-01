// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "Moya": .framework,
            "RxMoya": .framework,
            "RxSwift": .framework,
            "SnapKit": .framework,
            "Then": .framework,
            "RxCocoa": .framework,
            "KeychainSwift": .framework,
            "RxFlow": .framework,
            "Kingfisher": .framework,
            "Realm": .framework,
            "RealmSwift": .framework
        ]
    )
#endif

let package = Package(
    name: "FlowApp",
    dependencies: [
        .package(url: "https://github.com/BJCHO0501/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", from: "2.13.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.4.1"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.49.1")
    ]
)
