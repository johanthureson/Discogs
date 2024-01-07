//
//  ReleaseAPITests.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import XCTest
@testable import Discogs

final class ReleaseAPITests: XCTestCase {

    private var sut: ReleaseAPI!
    private var mockURLSession: MockURLSession!

    private enum TestError: Error {
        case testError
    }

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = ReleaseAPIImpl(session: mockURLSession)
    }

    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }

    func test_getReleases_createsCorrectURL() async {
        // Given
        mockURLSession.stubDataResponse = .success((Data(), URLResponse()))
        // When
        _ = try? await sut.getReleases()
        // Then
        XCTAssertEqual(mockURLSession.capturedURL?.host, "api.discogs.com")
        XCTAssertEqual(mockURLSession.capturedURL?.path, "/artists/1/releases")
        XCTAssertEqual(mockURLSession.capturedURL?.query(percentEncoded: false), "page=1&per_page=50")
    }

    func test_getReleases_returnsRelease() async {
        // Given
        let expectedDiscogsContent = DiscogsContent(releases: [Releases.sample()])
        let discogsContentData = try? JSONEncoder().encode(expectedDiscogsContent)
        mockURLSession.stubDataResponse = .success((discogsContentData ?? Data(), URLResponse()))
        // When
        let resultReleases = try? await sut.getReleases()
        // Then
        XCTAssertEqual(resultReleases!.first, expectedDiscogsContent.releases?.first)
    }

    func test_getReleases_returnsEmptyArray() async {
        // Given
        let expectedDiscogsContentWithEmptyReleaseArray = DiscogsContent(releases: [Releases]())
        let emptyData = try? JSONEncoder().encode(expectedDiscogsContentWithEmptyReleaseArray)
        mockURLSession.stubDataResponse = .success((emptyData ?? Data(), URLResponse()))
        // When
        let resultReleases = try? await sut.getReleases()
        // Then
        XCTAssertEqual(resultReleases, expectedDiscogsContentWithEmptyReleaseArray.releases)
    }

    func test_getReleases_invalidURL_throwsCouldNotConstructURLError() async {
        // Given
        sut = ReleaseAPIImpl(baseURL: "<>^`{|}", session: mockURLSession)
        do {
            // When
            _ = try await sut.getReleases()
            // Then
            XCTFail("Expected to fail")

        } catch {
            // Then
            XCTAssertEqual(error as? ReleaseAPIError, .couldNotConstructURL)
        }
    }

    func test_getReleases_offline_throwsError() async {
        // Given
        let testError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        mockURLSession.stubDataResponse = .failure(testError)
        do {
            // When
            _ = try await sut.getReleases()
            // Then
            XCTFail("Expected to fail")

        } catch {
            // Then
            XCTAssertEqual(error as? ReleaseAPIError, .offline)
        }
    }

    func test_getReleases_requestFailure_throwsError() async {
        // Given
        let testError = TestError.testError
        mockURLSession.stubDataResponse = .failure(testError)
        do {
            // When
            _ = try await sut.getReleases()
            // Then
            XCTFail("Expected to fail")

        } catch {
            // Then
            XCTAssertEqual(error as? TestError, testError)
        }
    }

    func test_getReleases_invalidJSON_throwsDecodingError() async {
        // Given
        let invalidJSONData = "invalid_json".data(using: .utf8)!
        mockURLSession.stubDataResponse = .success((invalidJSONData, URLResponse()))
        do {
            // When
            _ = try await sut.getReleases()
            // Then
            XCTFail("Expected to fail")

        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }

    func test_getReleases_emptyData_throwsDecodingError() async {
        // Given
        let emptyData = Data()
        mockURLSession.stubDataResponse = .success((emptyData, URLResponse()))
        do {
            // When
            _ = try await sut.getReleases()
            // Then
            XCTFail("Expected to fail")

        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
}
