//
//  ReleaseRepositoryTests.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import Combine
import XCTest
@testable import Discogs

final class ReleaseRepositoryTests: XCTestCase {

    var sut: ReleaseRepository!
    var mockReleaseAPI: MockReleaseAPI!
    var mockReleaseDB: MockReleaseDB!
    var cancel: AnyCancellable?

    private enum TestRepositoryError: Error, Equatable {
        case testError
    }

    override func setUp() {
        super.setUp()
        mockReleaseAPI = MockReleaseAPI()
        mockReleaseDB = MockReleaseDB()
        sut = ReleaseRepositoryImpl(api: mockReleaseAPI, db: mockReleaseDB)
    }

    override func tearDown() {
        cancel?.cancel()
        cancel = nil
        sut = nil
        mockReleaseAPI = nil
        mockReleaseDB = nil
        super.tearDown()
    }

    // MARK: - DataAccessStrategy.upToDateWithFallback

    func test_loadReleases_upToDateWithFallback_callsAPI() async {
        // Given
        mockReleaseAPI.stubGetReleasesResponse = .success([])
        mockReleaseDB.stubSaveReleasesResponse = .success(())
        // When
        await sut.loadReleases()
        // Then
        XCTAssertEqual(mockReleaseAPI.getReleasesCallCount, 1)
        XCTAssertEqual(mockReleaseDB.saveReleasesCallCount, 1)
    }

    func test_loadReleases_success_sendsReleasesToPublisher() async {
        // Given
        let expectedReleases = [Releases.sample()]
        mockReleaseAPI.stubGetReleasesResponse = .success(expectedReleases)
        mockReleaseDB.stubSaveReleasesResponse = .success(())
        // When
        if case .success(let releases) = await getLoadReleasesTestResult() {
            // Then
            XCTAssertEqual(releases, expectedReleases)
        } else {
            // Then
            XCTFail(#function)
        }
    }

    func test_loadReleases_failure_sendsErrorToPublisher() async {
        // Given
        let testError = TestRepositoryError.testError
        mockReleaseAPI.stubGetReleasesResponse = .failure(testError)
        mockReleaseDB.stubGetReleasesResponse = .failure(testError)
        // When
        if case .failure(let error) = await getLoadReleasesTestResult() {
            // Then
            XCTAssertEqual(error as? TestRepositoryError, testError)
        } else {
            // Then
            XCTFail(#function)
        }
    }

    // MARK: - Helpers -

    private func getLoadReleasesTestResult() async -> LoadingState<[Releases]>? {
        var testResult: LoadingState<[Releases]>?

        let exp = expectation(description: #function)
        cancel = sut.releasesPublisher
        /*
         When the Repository is set up, the publisher starts in the .idle state.
         When loadReleases() is called, the publisher immediately broadcasts the .loading state.
         After fetching data from the API, the publisher lands on the .success state with the beer values we care about.
         Therefore the two first needs to be dropped (.dropFirst(2)), otherwise we will get the error:
         "API violation - multiple calls made to -[XCTestExpectation fulfill] for getLoadReleasesTestResult()"
         */
            .dropFirst(2)
            .sink(receiveValue: {
                testResult = $0
                exp.fulfill()
            })

        await sut.loadReleases()
        await fulfillment(of: [exp], timeout: 1)

        return testResult
    }
}
