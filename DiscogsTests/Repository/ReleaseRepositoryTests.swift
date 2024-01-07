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
        mockReleaseAPI.stubGetReleasesResponse = .success([])
        mockReleaseDB.stubSaveReleasesResponse = .success(())
        await sut.loadReleases()
        XCTAssertEqual(mockReleaseAPI.getReleasesCallCount, 1)
        XCTAssertEqual(mockReleaseDB.saveReleasesCallCount, 1)
    }
    
    func test_loadReleases_success_sendsReleasesToPublisher() async {

        let expectedReleases = [Releases.sample()]
        mockReleaseAPI.stubGetReleasesResponse = .success(expectedReleases)
        mockReleaseDB.stubSaveReleasesResponse = .success(())

        if case .success(let releases) = await getLoadReleasesTestResult() {
            XCTAssertEqual(releases, expectedReleases)

        } else {
            XCTFail(#function)
        }
    }
    
    func test_loadReleases_failure_sendsErrorToPublisher() async {

        let testError = TestRepositoryError.testError
        mockReleaseAPI.stubGetReleasesResponse = .failure(testError)
        mockReleaseDB.stubGetReleasesResponse = .failure(testError)

        if case .failure(let error) = await getLoadReleasesTestResult() {
            XCTAssertEqual(error as? TestRepositoryError, testError)

        } else {
            XCTFail(#function)
        }
    }
    
    // MARK: - Helpers -
    
    private func getLoadReleasesTestResult() async -> LoadingState<[Releases]>? {
        var testResult: LoadingState<[Releases]>?
        
        let exp = expectation(description: #function)
        cancel = sut.releasesPublisher
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
