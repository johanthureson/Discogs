//
//  ReleaseTests.swift
//  DiscogsTests
//
//  Created by Johan Thureson on 2024-01-07.
//

import XCTest
@testable import Discogs

final class ReleaseTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func test_decodeJSON_parsesInformation() {
        
        guard let jsonData = getReleaseJSON().data(using: .utf8),
              let release = try? (decoder.decode(DiscogsContent.self, from: jsonData).releases ?? [Releases]()).first else {
            XCTFail("Failed to decode test data")
            return
        }
        
        XCTAssertEqual(release.id, 827783)
        XCTAssertEqual(release.artist, "The Persuader")
        XCTAssertEqual(release.title, "Skargard")
        XCTAssertEqual(release.year, 2015)
    }
    
    
    func test_decodeJSON_withInvalidDataFormat_throwsError() {
        
        do {
            let invalidData = "[{\"fake-data\"}]".data(using: .utf8)
            _ = try decoder.decode(DiscogsContent.self, from: invalidData!)
            XCTFail("Expected to fail")
            
        } catch {
            XCTAssertEqual(error.localizedDescription,
                           "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
    
    func test_equality_checksForMatchingID() {
        let releaseA = createRelease(id: 0, title: "Release A")
        let releaseB = createRelease(id: 1, title: "Release B")
        let releaseC = createRelease(id: 1, title: "Release C")
        
        XCTAssertTrue(releaseA != releaseB)
        XCTAssertTrue(releaseA != releaseC)
        XCTAssertTrue(releaseB == releaseC)
    }
    
    func test_optionalValues() {
        let release = createRelease(id: 0, title: "Release A", resource_url: nil, role: nil)

        XCTAssertNil(release.resource_url)
        XCTAssertNil(release.role)
    }

    func test_sample_createsSampleRelease() {
        let release = Releases.sample()
        
        XCTAssertEqual(release.id, 999)
        XCTAssertEqual(release.artist, "Depeche Mode")
        XCTAssertEqual(release.title, "Speak & Spell")
        XCTAssertEqual(release.year, 1981)
    }
    
    private func createRelease(id: Int, title: String, resource_url: String? = "", role: String? = "") -> Releases {
        Releases(id: id,
                 status: "",
                 type: "Record",
                 format: "LP",
                 label: "Mute",
                 title: title,
                 resource_url: resource_url,
                 role: role,
                 artist: "Depeche Mode",
                 year: 1981,
                 thumb: ""
        )

    }
    
    private func getReleaseJSON() -> String {
"""
{
"releases":[
    {
      "id": 827783,
      "title": "Skargard",
      "type": "master",
      "main_release": 6793647,
      "artist": "The Persuader",
      "role": "Main",
      "resource_url": "https://api.discogs.com/masters/827783",
      "year": 2015,
      "thumb": ""
    }
]
}
"""
    }
}
