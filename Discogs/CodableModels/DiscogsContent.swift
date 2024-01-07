import Foundation

public struct DiscogsContent: Codable {

    public let releases: [Releases]?

    enum CodingKeys: String, CodingKey {
        case releases = "releases"
    }

    public init(releases: [Releases]?) {
        self.releases = releases
    }
}
