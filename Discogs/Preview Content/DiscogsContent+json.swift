//
//  DiscogsContent+json.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-02-01.
//

import Foundation

extension DiscogsContent {
    
    static var exampleDiscogsContent = StaticFunctions.loadJson(DiscogsContent.self, fileName: "ExampleDiscogsContent")
    
}
