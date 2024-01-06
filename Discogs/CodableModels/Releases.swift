import Foundation

struct Releases : Codable, Identifiable {
	let id : Int?
	let status : String?
	let type : String?
	let format : String?
	let label : String?
	let title : String?
	let resource_url : String?
	let role : String?
	let artist : String?
	let year : Int?
	let thumb : String?
	let stats : Stats?

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
		case stats = "stats"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		format = try values.decodeIfPresent(String.self, forKey: .format)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		resource_url = try values.decodeIfPresent(String.self, forKey: .resource_url)
		role = try values.decodeIfPresent(String.self, forKey: .role)
		artist = try values.decodeIfPresent(String.self, forKey: .artist)
		year = try values.decodeIfPresent(Int.self, forKey: .year)
		thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
		stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
	}

}
