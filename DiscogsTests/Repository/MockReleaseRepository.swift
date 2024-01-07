//
//  MockReleaseRepository.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import Combine
import Foundation
@testable import Discogs

public final class MockReleaseRepository: ReleaseRepository {

    public var releasesPublisher = CurrentValueSubject<LoadingState<[Releases]>, Never>(.idle)

    init() { }

    var stubLoadReleasesResponse: LoadingState<[Releases]>?
    private(set) var loadReleasesCallCount = 0
    public func loadReleases() async {
        loadReleasesCallCount += 1
        releasesPublisher.send(stubLoadReleasesResponse!)
    }
}
