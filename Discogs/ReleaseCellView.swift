//
//  ReleaseCellView.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-06.
//

import SwiftUI

struct ReleaseCellView: View {
    
    let release: Releases
    
    var body: some View {
        VStack(alignment: .leading) {
            artist
            title
        }
    }
    
    @ViewBuilder
    private var artist: some View {
        if let artistName = release.artist {
            Text(artistName)
        }
    }

    @ViewBuilder
    private var title: some View {
        if let titleName = release.title {
            Text(titleName)
        }
    }

}

/*
#Preview {
    ReleaseCellView()
}
*/

