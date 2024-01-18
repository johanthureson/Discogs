import Foundation

public struct Labels: Codable, Equatable, Identifiable, Hashable {
    
    public let name : String?
    public let catno : String?
    public let entity_type : String?
    public let entity_type_name : String?
    public let id : Int?
    public let resource_url : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catno = "catno"
        case entity_type = "entity_type"
        case entity_type_name = "entity_type_name"
        case id = "id"
        case resource_url = "resource_url"
    }
    
    public init(
        name: String?,
        catno: String?,
        entity_type: String?,
        entity_type_name: String?,
        id: Int?,
        resource_url: String?
    ) {
        self.name = name
        self.catno = catno
        self.entity_type = entity_type
        self.entity_type_name = entity_type_name
        self.id = id
        self.resource_url = resource_url
    }
    
    public static func == (lhs: Labels, rhs: Labels) -> Bool {
        lhs.id == rhs.id
    }
    
}
