import Foundation

public struct Artists: Codable, Equatable, Identifiable, Hashable {
    
    public let name : String?
    public let anv : String?
    public let join : String?
    public let role : String?
    public let tracks : String?
    public let id : Int?
    public let resource_url : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case anv = "anv"
        case join = "join"
        case role = "role"
        case tracks = "tracks"
        case id = "id"
        case resource_url = "resource_url"
    }
    
    public init(
        name: String?,
        anv: String?,
        join: String?,
        role: String?,
        tracks: String?,
        id: Int?,
        resource_url: String?
    ) {
        self.name = name
        self.anv = anv
        self.join = join
        self.role = role
        self.tracks = tracks
        self.id = id
        self.resource_url = resource_url
    }
    
    public static func == (lhs: Artists, rhs: Artists) -> Bool {
        lhs.id == rhs.id
    }
    
}
