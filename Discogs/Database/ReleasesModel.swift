//
//  ReleasesModel.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import SwiftData

@Model
final class ReleasesModel {

    @Attribute(.unique) var id: Int?
    let status: String?
    let type: String?
    let format: String?
    let label: String?
    let title: String?
    let resource_url: String?
    let role: String?
    let artist: String?
    let year: Int?
    let thumb: String?

    var release: Releases {
        Releases(id: id,
                 status: status,
                 type: type,
                 format: format,
                 label: label,
                 title: title,
                 resource_url: resource_url,
                 role: role,
                 artist: artist,
                 year: year,
                 thumb: thumb
        )
    }

    init(release: Releases) {
        self.id = release.id
        self.status = release.status
        self.type = release.type
        self.format = release.format
        self.label = release.label
        self.title = release.title
        self.resource_url = release.resource_url
        self.role = release.role
        self.artist = release.artist
        self.year = release.year
        self.thumb = release.thumb
    }
}
