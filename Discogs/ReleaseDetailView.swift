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
        List {
            artist
            title
            status
            type
            format
            label
            role
            year
        }
        .navigationTitle(release.title ?? "")
    }
    
    @ViewBuilder
    private var artist: some View {
        if let artistName = release.artist {
            HStack {
                Text("Artist: ")
                Text(artistName)
            }
        }
    }
    
    @ViewBuilder
    private var title: some View {
        if let titleName = release.title {
            HStack {
                Text("Title: ")
                Text(titleName)
            }
        }
    }
    
    @ViewBuilder
    private var status: some View {
        if let statusString = release.status {
            HStack {
                Text("Status: ")
                Text(statusString)
            }
        }
    }
    
    @ViewBuilder
    private var type: some View {
        if let typeString = release.type {
            HStack {
                Text("Type: ")
                Text(typeString)
            }
        }
    }
    @ViewBuilder
    private var format: some View {
        if let formatString = release.format {
            HStack {
                Text("Format: ")
                Text(formatString)
            }
        }
    }
    @ViewBuilder
    private var label: some View {
        if let labelString = release.label {
            HStack {
                Text("Label: ")
                Text(labelString)
            }
        }
    }
    @ViewBuilder
    private var role: some View {
        if let roleString = release.role {
            HStack {
                Text("Role: ")
                Text(roleString)
            }
        }
    }
    @ViewBuilder
    private var year: some View {
        if let year = release.year {
            HStack {
                Text("Year: ")
                Text(String(year) )
            }
        }
    }
    
}
