//
//  City.swift
//  Test
//
//  Created by 이상준 on 2023/01/11.
//

import Foundation

struct City: Codable {
    let id: Int
    let name, country:String
    let coord: Coord
    
}

struct Coord: Codable {
    let lon, lat: Double
}

typealias CityArray = [City]
