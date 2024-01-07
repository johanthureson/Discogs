//
//  ReleaseAPI.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import Foundation

public protocol ReleaseAPI {
    func getReleases() async throws -> [Releases]
}

public enum ReleaseAPIError: LocalizedError {

    case couldNotConstructURL
    case offline

    public var errorDescription: String? {
        switch self {
        case .couldNotConstructURL:
            return "Could not construct URL correctly"

        case .offline:
            return "You appear to be offline"
        }
    }
}

public final class ReleaseAPIImpl: ReleaseAPI {

    private enum Constants {
        static let baseURL = "https://api.discogs.com/"
        static let releasesPath = "artists/1/releases"
    }

    private let baseURL: String
    private let session: URLSessionProtocol

    private lazy var decoder = {
        JSONDecoder()
    }()

    public init(baseURL: String? = nil,
                session: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL ?? Constants.baseURL
        self.session = session
    }

    public func getReleases() async throws -> [Releases] {

        let queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "50")
        ]

        guard let url = URL(string: baseURL, encodingInvalidCharacters: false)?
            .appendingPathComponent(Constants.releasesPath)
            .appending(queryItems: queryItems) else {
            throw ReleaseAPIError.couldNotConstructURL
        }

        do {
            let data = try await session.data(from: url).0
            return try decoder.decode(DiscogsContent.self, from: data).releases ?? []
        } catch let error as NSError
                    where error.domain == NSURLErrorDomain
                    && error.code == NSURLErrorNotConnectedToInternet {
            throw ReleaseAPIError.offline
        } catch {
            throw error
        }
    }
}
