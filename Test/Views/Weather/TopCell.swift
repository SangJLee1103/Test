//
//  TopCell.swift
//  Test
//
//  Created by 이상준 on 2023/01/14.
//

import UIKit
import RxSwift
import SnapKit

class TopCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    var viewModel = PublishSubject<ForecastViewModel>()
    
    
    // 시간 라벨
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.sizeToFit()
        return label
    }()
    
    // 날씨 이미지뷰
    private let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.4549019608, blue: 0.7019607843, alpha: 1)
        
        configureUI()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func configureUI() {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
        }
        
        addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(imgView.snp.width)
        }
        
        addSubview(tempLabel)
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func subscribe() {
        self.viewModel.subscribe(onNext: { forecastViewModel in
            self.timeLabel.text = forecastViewModel.dtTxt
            self.imgView.image = UIImage(named: forecastViewModel.conditionImage)
            self.tempLabel.text = forecastViewModel.temp
        }).disposed(by: disposeBag)
    }
}
