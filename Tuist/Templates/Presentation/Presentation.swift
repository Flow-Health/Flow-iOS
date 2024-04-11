import ProjectDescription

fileprivate let name: Template.Attribute = .required("name")

let presentationTemplate = Template(
    description: "make presentation template.",
    attributes: [name],
    items: PresentationTemplate.allCases.map { $0.items }
)

enum PresentationTemplate: CaseIterable {
    case viewController
    case viewModel

    var items: Template.Item {
        switch self {
        case .viewController:
            return .file(path: .basePath + "/\(name)ViewController.swift", templatePath: "ViewController.stencil")
        case .viewModel:
            return .file(path: .basePath + "/\(name)ViewModel.swift", templatePath: "ViewModel.stencil")
        }
    }
}

fileprivate extension String {
    static var basePath: Self {
        return "Projects/App/Sources/Scene/\(name)"
    }
}
