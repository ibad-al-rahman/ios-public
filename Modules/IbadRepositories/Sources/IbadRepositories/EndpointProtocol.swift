//
//  EndpointProtocol.swift
//  IbadRepositories
//
//  Created by Hamza Jadid on 02/12/2024.
//

import Foundation

protocol EndpointProtocol {
    var baseUrl: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

extension EndpointProtocol {
    var url: String { baseUrl + path }
}
