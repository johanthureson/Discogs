//
//  MockReleaseAPI.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import Foundation
@testable import Discogs

public final class MockReleaseAPI: ReleaseAPI {

    init() { }

    var stubGetReleasesResponse: Result<[Releases], Error>?
    private(set) var getReleasesCallCount = 0
    public func getReleases() async throws -> [Releases] {
        getReleasesCallCount += 1
        return try stubGetReleasesResponse.evaluate()
    }
}
