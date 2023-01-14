//
//  MainViewModel.swift
//  Test
//
//  Created by 이상준 on 2023/01/12.
//

import Foundation
import RxSwift

struct MainViewModel {
    
    // 현재 날씨 호출
    func fetchWeather(lat: Double, lon: Double) -> Observable<[WeatherViewModel]> {
        WeatherService().fetchWeather(lat: lat, lon: lon).map { $0.map { WeatherViewModel(weather: $0) }}
    }
    
    // 5일간 3시간 단위 날씨 호출
    func fetchForecast(lat: Double, lon: Double) -> Observable<[ForecastViewModel]> {
        WeatherService().fetchForecast(lat: lat, lon: lon).map { $0.map { ForecastViewModel(list: $0) }}
    }
}
