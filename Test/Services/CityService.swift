//
//  CityService.swift
//  Test
//
//  Created by 이상준 on 2023/01/11.
//

import Foundation
import RxSwift

struct CityService {
    
    // MARK: - 프로젝트 내에 있는 json 파일 Data 타입으로 바꾸어 리턴하는 함수
    func load() -> Data? {
        let fileName: String = "citylist"
        let type = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: type) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    func fetchCitys() -> Observable<CityArray> {
        return Observable.create { (observer) -> Disposable in
            self.fetchCitys() { (citys, error) in
                if let error = error {
                    observer.onError(error)
                }
                
                if let citys = citys {
                    observer.onNext(citys)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    // MARK: - 도시 정보 가져오는 로직
    func fetchCitys(completion: @escaping((CityArray?, Error?)) -> Void) {
        let jsonData = load()
        let cityList = try? JSONDecoder().decode(CityArray.self, from: jsonData!)
        
        if let cityList = cityList {
            return completion((cityList, nil))
        }
    }
}
