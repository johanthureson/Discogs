//
//  ReleaseRepository.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import Combine
import Foundation

public enum LoadingState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
}

public protocol ReleaseRepository {
    // Unlike PassthroughSubject, CurrentValueSubject maintains a buffer of the most recently published element.
    var releasesPublisher: CurrentValueSubject<LoadingState<[Releases]>, Never> { get }
    func loadReleases() async
}

public final class ReleaseRepositoryImpl: ReleaseRepository {

    public private(set) var releasesPublisher = CurrentValueSubject<LoadingState<[Releases]>, Never>(.idle)

    private let api: ReleaseAPI

    public init(
        api: ReleaseAPI = ReleaseAPIImpl()
    ) {
        self.api = api
    }

    public func loadReleases() async {
        releasesPublisher.send(.loading)
        do {
            try await upToDate()
        } catch {
            releasesPublisher.send(.failure(error))
        }
    }

    private func upToDate() async throws {
        let releases = try await api.getReleases()
        releasesPublisher.send(.success(releases))
    }

}
