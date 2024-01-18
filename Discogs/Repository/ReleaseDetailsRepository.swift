//
//  ReleaseDetailsRepository.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-01-18.
//

import Combine
import Foundation

public protocol ReleaseDetailsRepository {
    // Unlike PassthroughSubject, CurrentValueSubject maintains a buffer of the most recently published element.
    var releaseDetailsPublisher: CurrentValueSubject<LoadingState<ReleaseDetails>, Never> { get }
    func loadReleaseDetails(id: Int) async
}

public final class ReleaseDetailsRepositoryImpl: ReleaseDetailsRepository {
    
    public private(set) var releaseDetailsPublisher = CurrentValueSubject<LoadingState<ReleaseDetails>, Never>(.idle)
    
    private let api: ReleaseDetailsAPI
    
    public init(
        api: ReleaseDetailsAPI = ReleaseDetailsAPIImpl()
    ) {
        self.api = api
    }
    
    public func loadReleaseDetails(id: Int) async {
        releaseDetailsPublisher.send(.loading)
        do {
            let releases = try await api.getReleaseDetails(id: id)
            releaseDetailsPublisher.send(.success(releases))
        } catch {
            releaseDetailsPublisher.send(.failure(error))
        }
    }
    
}
