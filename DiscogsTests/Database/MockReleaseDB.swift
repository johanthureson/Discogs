//
//  MockReleaseDB.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import Foundation
@testable import Discogs

public final class MockReleaseDB: ReleaseDB {
    
    public init() { }
    
    var stubGetReleasesResponse: Result<[Releases], Error>?
    private(set) var getReleasesCallCount = 0
    public func getReleases() throws -> [Releases] {
        getReleasesCallCount += 1
        return try stubGetReleasesResponse.evaluate()
    }
    
    var stubSaveReleasesResponse: Result<Void, Error>?
    private(set) var saveReleasesCallCount = 0
    public func save(releases: [Releases]) throws {
        saveReleasesCallCount += 1
        return try stubSaveReleasesResponse.evaluate()
    }
}
