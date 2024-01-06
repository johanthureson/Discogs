//
//  ReleaseListView.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-06.
//

import SwiftUI

@Observable
final class ReleaseListViewModel {
    
    private (set) var title = "Hello, world!"
    
    private (set) var releases: [Releases]?

    init(title: String = "Hello, world!", releases: [Releases]? = nil) {
        self.title = title
        self.releases = releases
    }
    
    func loadDiscogs() async throws {
        let url = URL(string: "https://api.discogs.com/artists/1/releases?page=1&per_page=75")
        let request = URLRequest(url: url!)
        let (data, _) = try await URLSession.shared.data(for: request)
        let discogsContent = try JSONDecoder().decode(DiscogsContent.self, from: data)
        releases = discogsContent.releases
    }
}

struct ReleaseListView: View {
    
    @State var viewModel = ReleaseListViewModel()

    var body: some View {
        NavigationStack {
            List {
                releaseListSubView
            }
            .navigationTitle("Discogs Releases")
        }
        .padding()
        .task {
            do {
                try await viewModel.loadDiscogs()
            } catch {
                
            }
        }
    }
    
    private var releaseListSubView: some View {
        ForEach(viewModel.releases ?? []) { release in
            NavigationLink {
                ReleaseDetailView(release: release)
            } label: {
                VStack(alignment: .leading) {
                    Text(release.artist ?? "No artist name")
                    Text(release.title ?? "No title")
                }
            }
        }
    }

}

#Preview {
    ReleaseListView()
}
