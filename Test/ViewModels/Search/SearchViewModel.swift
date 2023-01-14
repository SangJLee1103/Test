//
//  MainViewModel.swift
//  Test
//
//  Created by 이상준 on 2023/01/11.
//

import Foundation
import RxSwift

struct SearchViewModel {
    
    func fetchCitys() -> Observable<[CityViewModel]> {
        CityService().fetchCitys().map{ $0.map { CityViewModel(city: $0) } }
    }
    
}
