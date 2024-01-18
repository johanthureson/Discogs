import Foundation

public struct Releases: Codable, Equatable, Identifiable, Hashable {

    public let id: Int?
    public let status: String?
    public let type: String?
    public let format: String?
    public let label: String?
    public let title: String?
    public let resource_url: String?
    public let role: String?
    public let artist: String?
    public let year: Int?
    public let thumb: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case status = "status"
        case type = "type"
        case format = "format"
        case label = "label"
        case title = "title"
        case resource_url = "resource_url"
        case role = "role"
        case artist = "artist"
        case year = "year"
        case thumb = "thumb"
    }

    public init(
        id: Int?,
        status: String?,
        type: String?,
        format: String?,
        label: String?,
        title: String?,
        resource_url: String?,
        role: String?,
        artist: String?,
        year: Int?,
        thumb: String?
    ) {
        self.id = id
        self.status = status
        self.type = type
        self.format = format
        self.label = label
        self.title = title
        self.resource_url = resource_url
        self.role = role
        self.artist = artist
        self.year = year
        self.thumb = thumb
    }

    public static func == (lhs: Releases, rhs: Releases) -> Bool {
        lhs.id == rhs.id
    }

    public static func sample(id: Int = 999, artist: String = "Speak & Spell") -> Releases {
        Releases(id: id,
                 status: "",
                 type: "Record",
                 format: "LP",
                 label: "Mute",
                 title: "Speak & Spell",
                 resource_url: "",
                 role: "",
                 artist: "Depeche Mode",
                 year: 1981,
                 thumb: ""
        )
    }
}
