//
//  PublicationEndpoint.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/01/2025.
//

struct PublicationEndpoint {
    static let baseUrl = "https://www.ibad.org.lb/doc"

    static func endpoint(id: String) -> String {
        "\(baseUrl)/\(id).pdf"
    }
}
