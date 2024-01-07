import Foundation

struct Community: Codable {
	let in_wantlist: Int?
	let in_collection: Int?

	enum CodingKeys: String, CodingKey {
		case in_wantlist = "in_wantlist"
		case in_collection = "in_collection"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		in_wantlist = try values.decodeIfPresent(Int.self, forKey: .in_wantlist)
		in_collection = try values.decodeIfPresent(Int.self, forKey: .in_collection)
	}

}
