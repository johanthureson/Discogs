//
//  MockURLSession.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import Foundation
@testable import Discogs

public final class MockURLSession: URLSessionProtocol {
    
    public init() { }
    
    var stubDataResponse: Result<(Data, URLResponse), Error>?
    var capturedURL: URL?
    public func data(from url: URL) async throws -> (Data, URLResponse) {
        capturedURL = url
        return try stubDataResponse.evaluate()
    }
}
