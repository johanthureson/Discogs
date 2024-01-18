//
//  ReleaseDetailsAPI.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-18.
//

import Foundation

public protocol ReleaseDetailsAPI {
    func getReleaseDetails(id: Int) async throws -> ReleaseDetails
}

public final class ReleaseDetailsAPIImpl: ReleaseDetailsAPI {
    
    private enum Constants {
        static let baseURL = "https://api.discogs.com/"
        static let releasesPath = "releases/"
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
    
    public func getReleaseDetails(id: Int) async throws -> ReleaseDetails {
        
        /*
         According to this article:
         https://nshipster.com/secrets/
         "Client Secrecy is Impossible",
         so I will leave the key and secret in the open.
         Setting up a server to host the key and secret is not the scope of this project.
         But would be recommended otherwise.
         The worst that can happen is that someone uses my quota.
         But easier for that person would be to get a free key of their own here:
         https://www.discogs.com/settings/developers
         */
        
        let queryItems = [
            URLQueryItem(name: "key", value: "MgXJxAyflKxSzofCLeEQ"),
            URLQueryItem(name: "secret", value: "tlGZwRdeXzwIuSAqNQzWdaaeFXRsvzxB")
        ]
        
        guard let url = URL(string: baseURL, encodingInvalidCharacters: false)?
            .appendingPathComponent(Constants.releasesPath)
            .appendingPathComponent(String(id))
            .appending(queryItems: queryItems) else {
            throw ReleaseAPIError.couldNotConstructURL
        }
        
        do {
            let data = try await session.data(from: url).0
            return try decoder.decode(ReleaseDetails.self, from: data)
        } catch let error as NSError
                    where error.domain == NSURLErrorDomain
                    && error.code == NSURLErrorNotConnectedToInternet {
            throw ReleaseAPIError.offline
        } catch {
            throw error
        }
    }
}
