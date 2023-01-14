//
//  CityViewModel.swift
//  Test
//
//  Created by 이상준 on 2023/01/11.
//

import Foundation

struct CityViewModel {
    private let city: City
    
    var id: Int? {
        return city.id
    }
    
    var name: String? {
        return city.name
    }
    
    var country: String? {
        return city.country
    }
    
    var lon: Double? {
        city.coord.lon
    }
    
    var lat: Double? {
        city.coord.lat
    }
    
    init(city: City) {
        self.city = city
    }
}
