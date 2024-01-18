import Foundation

struct Images: Codable, Equatable, Hashable {    
    
    public let type : String?
    public let uri : String?
    public let resource_url : String?
    public let uri150 : String?
    public let width : Int?
    public let height : Int?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case uri = "uri"
        case resource_url = "resource_url"
        case uri150 = "uri150"
        case width = "width"
        case height = "height"
    }
    
    public init(
        type : String?,
        uri : String?,
        resource_url : String?,
        uri150 : String?,
        width : Int?,
        height : Int?
    ) {
        self.type = type
        self.uri = uri
        self.resource_url = resource_url
        self.uri150 = uri150
        self.width = width
        self.height = height
    }
    
    public static func == (lhs: Images, rhs: Images) -> Bool {
        lhs.uri == rhs.uri
    }
    
}
