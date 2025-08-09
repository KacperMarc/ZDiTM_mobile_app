//
//  LineInformation.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 19/02/2025.
//
import Foundation

struct LineInformation: Codable {
    let rodzaj: String
    let kierunki: String
    let przebieg: String
    let przystanki_do:[String]
    let przystanki_od: [String]
}
