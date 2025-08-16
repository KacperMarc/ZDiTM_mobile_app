//
//  EndpointPorotocol.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 16/08/2025.
//

import Foundation

protocol Endpoint {
    var request: URLRequest { get }
    var responseType: Decodable.Type { get }
}
