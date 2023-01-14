//
//  WeatherService.swift
//  Test
//
//  Created by 이상준 on 2023/01/12.
//

import Foundation
import Alamofire
import RxSwift

struct WeatherService {
    let appid = Bundle.main.apiKey
    
    // 현재 날씨
    func fetchWeather(lat: Double, lon: Double) -> Observable<[List]> {
        return Observable.create { (observer) ->
            Disposable in
            self.fetchWeather(lat: lat, lon: lon) { (weather, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                if let weather = weather {
                    observer.onNext(weather)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(([List]?, Error?) -> Void)) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: List.self) { response in
            if let error = response.error {
                return completion(nil, error)
            }
            
            if let weather = response.value {
                return completion([weather], nil)
            }
        }
    }
    
    // 5일 / 3시간 예보
    func fetchForecast(lat: Double, lon: Double) -> Observable<[List]> {
        return Observable.create { (observer) ->
            Disposable in
            self.fetchForecast(lat: lat, lon: lon) { (weather, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                if let weather = weather {
                    observer.onNext(weather)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchForecast(lat: Double, lon: Double, completion: @escaping(([List]?, Error?) -> Void)) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(appid)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: WeatherModel.self) { response in
            if let error = response.error {
                return completion(nil, error)
            }
            
            if let weather = response.value?.list {
                return completion(weather, nil)
            }
        }
    }
}

