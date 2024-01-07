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
                .overlay(loadingIndicator)
                .navigationTitle(viewModel.title)
                .toolbar(.automatic, for: .navigationBar)
        }
        .alert(isPresented: $viewModel.showAlert) { errorAlert }
        .task { await viewModel.loadReleases() }
    }
    
    private var releaseListSubView: some View {
        List {
            ForEach(viewModel.releases) { release in
                NavigationLink {
                    ReleaseDetailView(release: release)
                } label: {
                    ReleaseCellView(release: release)
                }
            }
        }
    }


    @ViewBuilder
    private var loadingIndicator: some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }
    
    private var errorAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text(viewModel.errorMessage ?? ""),
            dismissButton: .default(Text("OK")) {
                viewModel.showAlert.toggle()
            }
        )
    }
}

#Preview {
    ReleaseListView()
}
