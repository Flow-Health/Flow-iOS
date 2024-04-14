import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")

let moduleTemplate = Template(
    description: "Template for module.",
    attributes: [name],
    items: ModuleTemplate.allCases.map { $0.item }
)

enum ModuleTemplate: CaseIterable {
    case project
    case temp

    var item: Template.Item {
        switch self {
        case .project:
            return .file(path: .basePath + "/Project.swift", templatePath: "Project.stencil")
        case .temp:
            return .file(path: .basePath + "/Sources/Temp.swift", templatePath: "Temp.stencil")
        }
    }
}

fileprivate extension String {
    static var basePath: Self {
        return "Projects/Modules/\(name)"
    }
}
