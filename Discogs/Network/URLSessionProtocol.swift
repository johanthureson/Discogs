//
//  URLSessionProtocol.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-07.
//

import Foundation

public protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }
