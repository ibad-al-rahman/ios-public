//
//  PublicationRemoteRepo.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/01/2025.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct PublicationRemoteRepo: Sendable {
    public var downloadPublication: @Sendable (
        _ id: String,
        _ to: URL
    ) async -> Result<(), ServiceError> = {
        _, _ in .failure(.unknown)
    }
}

extension PublicationRemoteRepo: DependencyKey {
    public static var liveValue: PublicationRemoteRepo {
        let service = PublicationService()

        return PublicationRemoteRepo(
            downloadPublication: {
                await service.downloadPublication(id: $0, to: $1)
            }
        )
    }
}

extension PublicationRemoteRepo: TestDependencyKey {
    public static var previewValue: PublicationRemoteRepo {
        PublicationRemoteRepo()
    }

    public static var testValue: PublicationRemoteRepo {
        PublicationRemoteRepo()
    }
}

public extension DependencyValues {
    var publicationRemoteRepo: PublicationRemoteRepo {
        get { self[PublicationRemoteRepo.self] }
        set { self[PublicationRemoteRepo.self] = newValue }
    }
}

