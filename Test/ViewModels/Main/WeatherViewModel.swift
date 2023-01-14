//
//  WeatherViewModel.swift
//  Test
//
//  Created by 이상준 on 2023/01/14.
//

import Foundation

struct WeatherViewModel {
    private let weather: List
    
    // 기온
    var temp: String {
        return String(format: "%.0f°", weather.main.temp - 273.15)
    }
    
    // 최대 기온
    var tempMax: String {
        return String(format: "최고:%.0f°", weather.main.tempMax - 273.15)
    }
    
    // 최소 기온
    var tempMin: String {
        return String(format: "최저:%.0f°", weather.main.tempMin - 273.15)
    }
    
    // 날씨 코드
    var id: Int {
        return weather.weather[0].id
    }
    
    // 습도
    var humidity: String {
        return "\(weather.main.humidity)%"
    }
    
    // 구름
    var clouds: String {
        return "\(weather.clouds.all)%"
    }
    
    // 바람속도
    var wind: String {
        return "\(weather.wind.speed)m/s"
    }
    
    var conditionName: String {
            switch id {
            case 200...232:
                return "뇌우"
            case 300...321:
                return "이슬비"
            case 500...531:
                return "비"
            case 600...622:
                return "눈"
            case 701...781:
                return "흐림"
            case 800:
                return "맑음"
            default:
                return "구름"
            }
        }
    
    var conditionImage: String {
            switch id {
            case 200...232:
                return "11d"
            case 300...321:
                return "09d"
            case 500...504:
                return "10d"
            case 511:
                return "13d"
            case 520...531:
                return "09d"
            case 600...622:
                return "13d"
            case 701...781:
                return "50d"
            case 800:
                return "01d"
            case 801:
                return "02d"
            case 802:
                return "03d"
            case 803:
                return "04d"
            case 804:
                return "04d"
            default:
                return "cloud"
            }
        }
    
    
    init(weather: List) {
        self.weather = weather
    }
}
