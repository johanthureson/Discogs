//
//  ReleaseListView.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-06.
//

import SwiftUI

struct ReleaseListView: View {
    
    @State private var viewModel = ReleaseListViewModel()

    var body: some View {
        NavigationStack {
            releaseListSubView
                .navigationTitle(viewModel.title)
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
        List {
            ForEach(viewModel.releases ?? []) { release in
                NavigationLink {
                    ReleaseDetailView(release: release)
                } label: {
                    ReleaseCellView(release: release)
                }
            }
        }
    }

}

#Preview {
    ReleaseListView()
}
