//
//  ReleaseListViewModel.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import SwiftUI

@Observable
final class ReleaseListViewModel {
    
    private (set) var title = "Discogs Releases"
    
    private (set) var releases: [Releases]?

    init(releases: [Releases]? = nil) {
        self.releases = releases
    }
    
    func loadDiscogs() async throws {
        guard let url = URL(string: "https://api.discogs.com/artists/1/releases?page=1&per_page=75") else {
            return
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let discogsContent = try JSONDecoder().decode(DiscogsContent.self, from: data)
        releases = discogsContent.releases
    }
}

