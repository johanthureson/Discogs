//
//  ReleaseListViewModel.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import SwiftUI

@Observable
final class ReleaseListViewModel {

    private(set) var title = "Discogs Releases"
    private(set) var isLoading: Bool = false
    var showAlert: Bool = false

    private(set) var errorMessage: String?

    private(set) var releases: [Releases] // = []
    private let repository: ReleaseRepository

    init(releases: [Releases] = [],
         repository: ReleaseRepository = ReleaseRepositoryImpl()) {
        self.releases = releases
        self.repository = repository
        guard releases.count == 0 else {
            return
        }
        Task {
            await setupReleaseSequence()
        }
    }

    func loadReleases() async {
        await repository.loadReleases()
    }

    private func setupReleaseSequence() async {
        // An AsyncSequence resembles the Sequence type — offering a list of values you can step through one at a time — and adds asynchronicity
        // So this for loop goes through the loadingState, going to the next loop, when the next stage in the loadingState happens
        for await loadingState in repository.releasesPublisher.values {
            await handleRelease(loadingState: loadingState)
        }
    }

    @MainActor
    private func handleRelease(loadingState: LoadingState<[Releases]>) {
        switch loadingState {

        case .idle:
            isLoading = false

        case .loading:
            isLoading = true

        case .success(let releases):
            isLoading = false
            self.releases = keepOnlyReleaseType(releases: releases)

        case .failure(let error):
            isLoading = false
            showAlert.toggle()
            errorMessage = error.localizedDescription
        }
    }
    
    // The releases list is of mixed types (at least both type release and master)
    // To keep the detail view simpler, only the release type was kept
    private func keepOnlyReleaseType(releases: [Releases]) -> [Releases] {
        return releases.filter { relese in
            relese.type == "release"
        }
    }
    
}
