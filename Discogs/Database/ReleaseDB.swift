//
//  ReleaseDB.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import Foundation
import SwiftData

public protocol ReleaseDB {
    func getReleases() async throws -> [Releases]
    func save(releases: [Releases]) async throws
}

public final class ReleaseDBImpl: ReleaseDB {

    private let container: ModelContainer

    public init() throws {
        container = try ModelContainer(for: ReleasesModel.self)
    }

    @MainActor
    public func getReleases() async throws -> [Releases] {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<ReleasesModel>(
            sortBy: [SortDescriptor<ReleasesModel>(\.id)]
        )
        let releaseModels = try context.fetch(fetchDescriptor)
        return releaseModels.map { $0.release }
    }

    @MainActor
    public func save(releases: [Releases]) throws {
        let context = container.mainContext
        releases
            .map { ReleasesModel(release: $0) }
            .forEach {
                context.insert($0)
            }
        try context.save()
    }
}
