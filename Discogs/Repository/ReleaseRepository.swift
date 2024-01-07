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
    var releasesPublisher: CurrentValueSubject<LoadingState<[Releases]>, Never> { get }
    func loadReleases() async
}

public final class ReleaseRepositoryImpl: ReleaseRepository {

    public private(set) var releasesPublisher = CurrentValueSubject<LoadingState<[Releases]>, Never>(.idle)

    private let api: ReleaseAPI
    private let db: ReleaseDB?

    public init(
        api: ReleaseAPI = ReleaseAPIImpl(),
        db: ReleaseDB? = try? ReleaseDBImpl()
    ) {
        self.api = api
        self.db = db
    }

    public func loadReleases() async {
        releasesPublisher.send(.loading)
        do {
            try await upToDateWithFallback()
        } catch {
            releasesPublisher.send(.failure(error))
        }
    }

    private func upToDateWithFallback() async throws {
        do {
            let releases = try await api.getReleases()
            try? await db?.save(releases: releases)
            releasesPublisher.send(.success(releases))
        } catch {
            if let releases = try? await db?.getReleases() {
                releasesPublisher.send(.success(releases))
            } else {
                throw error
            }
        }
    }

    // MARK: - Testing Helpers

    private func createRelease(id: Int? = 999, artist: String? = "Depeche Mode", title: String? = "Speak & Spell") -> Releases {
        Releases(id: id,
                 status: "",
                 type: "Record",
                 format: "LP",
                 label: "Mute",
                 title: title,
                 resource_url: "",
                 role: "",
                 artist: artist,
                 year: 1981,
                 thumb: ""
        )
    }
}
