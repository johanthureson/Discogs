//
//  ReleaseListViewModelTests.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import XCTest
@testable import Discogs

final class ReleaseListViewModelTests: XCTestCase {
    
    var sut: ReleaseListViewModel!
    var mockReleaseRepository: MockReleaseRepository!
    
    private enum TestViewModelError: LocalizedError {
        case testError
        
        var errorDescription: String {
            switch self {
            case .testError: return "Test error"
            }
        }
    }
    
    override func setUp() {
        super.setUp()
        mockReleaseRepository = MockReleaseRepository()
    }
    
    override func tearDown() {
        sut = nil
        mockReleaseRepository = nil
        super.tearDown()
    }
    
    // MARK: - Test functions -
    
    func test_initialState() {
        sut = ReleaseListViewModel(repository: mockReleaseRepository)
        XCTAssertTrue(sut.releases.isEmpty)
        XCTAssertFalse(sut.showAlert)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadReleases_callsLoadOnRepository() async {
        sut = ReleaseListViewModel(repository: mockReleaseRepository)
        mockReleaseRepository.stubLoadReleasesResponse = .success([])
        await sut.loadReleases()
        XCTAssertEqual(mockReleaseRepository.loadReleasesCallCount, 1)
    }
    
    func test_listenerSentReleasesSuccessfully_setsReleases() {
        sut = ReleaseListViewModel(repository: mockReleaseRepository)
        let sampleReleases = [Releases.sample()]
        mockReleaseRepository.releasesPublisher.send(.success(sampleReleases))
        waitForChanges(to: \.releases, on: sut)
        XCTAssertEqual(sampleReleases, sut.releases)
    }
    
    func test_listenerSentOfflineError_setsErrorMessageAndTogglesAlert() {
        sut = ReleaseListViewModel(repository: mockReleaseRepository)
        let testError = ReleaseAPIError.offline
        mockReleaseRepository.releasesPublisher.send(.failure(testError))
        waitForChanges(to: \.showAlert, on: sut)
        XCTAssertEqual(sut.errorMessage, ReleaseAPIError.offline.errorDescription)
        XCTAssertTrue(sut.showAlert)
    }
    
    func test_listenerSentURLError_setsErrorMessageAndTogglesAlert() {
        sut = ReleaseListViewModel(repository: mockReleaseRepository)
        let testError = ReleaseAPIError.couldNotConstructURL
        mockReleaseRepository.releasesPublisher.send(.failure(testError))
        waitForChanges(to: \.showAlert, on: sut)
        XCTAssertEqual(sut.errorMessage, ReleaseAPIError.couldNotConstructURL.errorDescription)
        XCTAssertTrue(sut.showAlert)
    }
    
    func test_listenerSentError_setsErrorMessageAndTogglesAlert() {
        sut = ReleaseListViewModel(repository: mockReleaseRepository)
        let testError = TestViewModelError.testError
        mockReleaseRepository.releasesPublisher.send(.failure(testError))
        waitForChanges(to: \.showAlert, on: sut)
        XCTAssertEqual(sut.errorMessage, testError.localizedDescription)
        XCTAssertTrue(sut.showAlert)
    }
    
    // MARK: - Helper function -

    /// Waits for changes to a property at a given key path of an `@Observable` entity.
    ///
    /// Uses the Observation framework's global `withObservationTracking` function to track changes to a specific property.
    /// By using wildcard assignment (`_ = ...`), we 'touch' the property without wasting CPU cycles.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to observe.
    ///   - parent: The observable view model that contains the property.
    ///   - timeout: The time (in seconds) to wait for changes before timing out. Defaults to `1.0`.
    ///
    func waitForChanges<T, U>(to keyPath: KeyPath<T, U>, on parent: T, timeout: Double = 1.0) {
        let exp = expectation(description: #function)
        withObservationTracking {
            _ = parent[keyPath: keyPath]
        } onChange: {
            exp.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

}

