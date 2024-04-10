import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")

let moduleWithTestTemplate = Template(
    description: "Template for module",
    attributes: [name],
    items: ModuleWithTestTemplate.allCases.map { $0.item }
)

enum ModuleWithTestTemplate: CaseIterable {
    case project
    case temp
    case test

    var item: Template.Item {
        switch self {
        case .project:
            return .file(path: .basePath + "/Project.swift", templatePath: "Project.stencil")
        case .temp:
            return .file(path: .basePath + "/Sources/Temp.swift", templatePath: "Temp.stencil")
        case .test:
            return .file(path: .basePath + "/\(name)Tests/\(name)Test.swift", templatePath: "Test.stencil")
        }
    }
}

fileprivate extension String {
    static var basePath: Self {
        return "Projects/Modules/\(name)"
    }
}
