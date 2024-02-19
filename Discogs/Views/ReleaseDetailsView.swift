//
//  ReleaseDetailView.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-06.
//

import SwiftUI

struct ReleaseDetailsView: View {

    let id: Int
    @State private var viewModel = ReleaseDetailsViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        List {
            artists
            title
            year
            genres
            thumb
        }
        .overlay(loadingIndicator)
        .navigationTitle(viewModel.title)
        .toolbar(.automatic, for: .navigationBar)
        .alert(isPresented: $viewModel.showAlert) { errorAlert }
        .task { await viewModel.loadReleaseDetails(id: id) }
        .accessibilityAction(.magicTap) {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    @ViewBuilder
    private var artists: some View {
        if let artists = viewModel.releaseDetails?.artists {
            VStack {
                HStack {
                    Text("Artists: ")
                    Text(artistsString(artists: artists))
                }
                Text("This Scales")
                    .font(.custom("Georgia", size: 24))
                    .accessibility(sortPriority: 0)

                Text("This is Fixed")
                    .font(.custom("Georgia", fixedSize: 24))
                    .accessibility(sortPriority: 1)
            }
            .accessibilityElement(children: .contain)
        }
    }

    @ViewBuilder
    private var title: some View {
        if let titleName = viewModel.releaseDetails?.title {
            HStack {
                Text("Title: ")
                Text(titleName)
            }
        }
    }

    @ViewBuilder
    private var year: some View {
        if let year = viewModel.releaseDetails?.year {
            HStack {
                Text("Year: ")
                Text(String(year) )
            }
        }
    }
    
    @ViewBuilder
    private var genres: some View {
        if let genres = viewModel.releaseDetails?.genres {
            HStack {
                Text("Genres: ")
                Text(stringArrayToString(stringArray: genres))
            }
        }
    }
    
    @ViewBuilder
    private var thumb: some View {
        if let thumb = viewModel.releaseDetails?.thumb {
            HStack {
                Spacer()
                RemoteImageView(url: thumb)
                    .frame(width: 150, height: 150, alignment: .center)
                    .cornerRadius(10)
                    .accessibilityLabel("Image")
                    .accessibilityHint("Image of record")
                Spacer()
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

    private func artistsString(artists: [Artists]) -> String {
        var artisstString = ""
        for artist in artists {
            if let artistName = artist.name {
                artisstString.append(artistName + ", ")
            }
        }
        if artisstString.count >= 2 {
            artisstString = String(artisstString.dropLast(2))
        }
        return artisstString
    }
    
    private func stringArrayToString(stringArray: [String]) -> String {
        var stringArrayString = ""
        for string in stringArray {
            stringArrayString.append(string + ", ")
        }
        if stringArrayString.count >= 2 {
            stringArrayString = String(stringArrayString.dropLast(2))
        }
        return stringArrayString
    }

}
