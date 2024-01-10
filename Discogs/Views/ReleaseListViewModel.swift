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
    private(set) var releases: [Releases] = []
    private(set) var isLoading: Bool = false
    var showAlert: Bool = false

    private(set) var errorMessage: String?

    private let repository: ReleaseRepository

    init(repository: ReleaseRepository = ReleaseRepositoryImpl()) {
        self.repository = repository
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
            self.releases = releases

        case .failure(let error):
            isLoading = false
            showAlert.toggle()
            errorMessage = error.localizedDescription
        }
    }
}
