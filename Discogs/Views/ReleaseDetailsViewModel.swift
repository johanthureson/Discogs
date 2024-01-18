//
//  ReleaseDetailsViewModel.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-18.
//

import SwiftUI

@Observable
final class ReleaseDetailsViewModel {

    private(set) var title = "Release Details"
    private(set) var releaseDetails: ReleaseDetails?
    private(set) var isLoading: Bool = false
    var showAlert: Bool = false

    private(set) var errorMessage: String?

    private let repository: ReleaseDetailsRepository

    init(repository: ReleaseDetailsRepository = ReleaseDetailsRepositoryImpl()) {
        self.repository = repository
        Task {
            await setupReleaseSequence()
        }
    }

    func loadReleaseDetails(id: Int) async {
        await repository.loadReleaseDetails(id: id)
    }

    private func setupReleaseSequence() async {
        // An AsyncSequence resembles the Sequence type — offering a list of values you can step through one at a time — and adds asynchronicity
        // So this for loop goes through the loadingState, going to the next loop, when the next stage in the loadingState happens
        for await loadingState in repository.releaseDetailsPublisher.values {
            await handleRelease(loadingState: loadingState)
        }
    }

    @MainActor
    private func handleRelease(loadingState: LoadingState<ReleaseDetails>) {
        switch loadingState {

        case .idle:
            isLoading = false

        case .loading:
            isLoading = true

        case .success(let releaseDetails):
            isLoading = false
            self.releaseDetails = releaseDetails

        case .failure(let error):
            isLoading = false
            showAlert.toggle()
            errorMessage = error.localizedDescription
        }
    }
}
