//
//  PublicationService.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/01/2025.
//

import Alamofire
import Foundation
import OSLog

struct PublicationService {
    func downloadPublication(
        id: String, to destination: URL
    ) async -> Result<(), ServiceError> {
        let endpoint = PublicationEndpoint.endpoint(id: id)
        let url = destination.appendingPathExtension("pdf")

        return await withCheckedContinuation { continuation in
            AF
                .download(endpoint)
                .downloadProgress { progress in
                    Logger.remote.info("Progress \(progress.fractionCompleted)")
                }
                .responseData { response in
                    guard let data = response.value else {
                        Logger.remote.info("Failed to download \(id)")
                        continuation.resume(returning: .failure(.unknown))
                        return
                    }
                    Logger.remote.info("Successfully downloaded \(id)")
                    do {
                        try data.write(to: url)
                        Logger.remote.info("Saved on disk \(id)")
                        continuation.resume(returning: .success(()))
                    } catch {
                        Logger.remote.error("Failed to save on disk \(id)")
                        continuation.resume(returning: .failure(.unknown))
                    }
                }
        }
    }
}
