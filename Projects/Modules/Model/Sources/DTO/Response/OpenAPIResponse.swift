// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

/// 일반약  OpenAPI를 위한  DTO

public struct OpenAPIResponse: Decodable {
    public let body: SearchResultResponse?
}
