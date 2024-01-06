//
//  ReleaseDetailView.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-06.
//

import SwiftUI

struct ReleaseDetailView: View {
    
    let release: Releases
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(release.artist ?? "No artist name")
            Text(release.title ?? "No title")
        }
    }
}

/*
#Preview {
    ReleaseDetailView()
}
*/
