//
//  CityCell.swift
//  Test
//
//  Created by 이상준 on 2023/01/11.
//

import UIKit
import RxSwift
import SnapKit

class SearchCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    var viewModel = PublishSubject<CityViewModel>()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(cityLabel)
        cityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(20)
        }
        
        addSubview(countryLabel)
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func subscribe() {
        self.viewModel.subscribe(onNext: { cityViewModel in
            self.cityLabel.text = cityViewModel.name
            self.countryLabel.text = cityViewModel.country
        }).disposed(by: disposeBag)
    }
}
