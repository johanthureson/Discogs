import Foundation

struct DiscogsContent : Codable {
	let releases : [Releases]?

	enum CodingKeys: String, CodingKey {
		case releases = "releases"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		releases = try values.decodeIfPresent([Releases].self, forKey: .releases)
	}

}
