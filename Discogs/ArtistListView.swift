//
//  ArtistListView.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-06.
//

import SwiftUI

@Observable
final class ArtistListViewModel {
    private (set) var title = "Hello, world!"
}

struct ArtistListView: View {
    
    @State var viewModel = ArtistListViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(viewModel.title)
        }
        .padding()
    }
}

#Preview {
    ArtistListView()
}
