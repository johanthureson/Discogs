import Foundation

public struct ReleaseDetails: Codable, Equatable, Identifiable, Hashable {
    
    public let id : Int?
    public let year : Int?
    public let artists : [Artists]?
    public let labels : [Labels]?
    public let title : String?
    public let released : String?
    public let genres : [String]?
    public let styles : [String]?
    public let images : [Images]?
    public let thumb : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case year = "year"
        case artists = "artists"
        case labels = "labels"
        case title = "title"
        case released = "released"
        case genres = "genres"
        case styles = "styles"
        case images = "images"
        case thumb = "thumb"
    }
    
    public init(
        id: Int?,
        year: Int?,
        artists: [Artists]?,
        labels: [Labels]?,
        title: String?,
        released: String?,
        genres: [String]?,
        styles: [String]?,
        images: [Images]?,
        thumb: String?
    ) {
        self.id = id
        self.year = year
        self.artists = artists
        self.labels = labels
        self.title = title
        self.released = released
        self.genres = genres
        self.styles = styles
        self.images = images
        self.thumb = thumb
    }
    
    public static func == (lhs: ReleaseDetails, rhs: ReleaseDetails) -> Bool {
        lhs.id == rhs.id
    }
    
}
