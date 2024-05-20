// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public struct Environment {
    public enum Key: String {
        case baseURL = "BASE_URL"
        case openApiServiceKey = "OPEN_API_SERVICE_KEY"
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle(identifier: "com.flow-health.Core")?.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    public static func getValue(key: Key) -> String {
        guard let value = Environment.infoDictionary[key.rawValue] as? String else {
            fatalError("can`t found \(key.rawValue) from Plist.")
        }
        return value
    }
}
