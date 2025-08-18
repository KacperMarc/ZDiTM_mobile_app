//
//  LineInformation.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 19/02/2025.
//
import Foundation

struct LineInformation: Codable {
    let type: String
    let directions: String
    let course: String
    let stopsTowards:[String]
    let stopsBackwards: [String]
}
