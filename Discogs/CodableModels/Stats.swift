import Foundation

struct Stats: Codable {
	let community: Community?

	enum CodingKeys: String, CodingKey {
		case community = "community"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		community = try values.decodeIfPresent(Community.self, forKey: .community)
	}

}
