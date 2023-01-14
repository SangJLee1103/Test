//
//  WeatherViewController.swift
//  Test
//
//  Created by 이상준 on 2023/01/12.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class MainViewController: UIViewController {
    
    let viewModel: MainViewModel
    let disposeBag = DisposeBag()
    
    
    var weatherViewModel = BehaviorRelay<[WeatherViewModel]>(value: [])
    var weatherViewModelObserver: Observable<[WeatherViewModel]> {
        return weatherViewModel.asObservable()
    }
    
    var forecastViewModel = BehaviorRelay<[ForecastViewModel]>(value: [])
    var forecastViewModelObserver: Observable<[ForecastViewModel]> {
        return forecastViewModel.asObservable()
    }
    
    var city: String? = "Asan"
    var lon: Double? = 127.004173
    var lat: Double? = 36.783611
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.4549019608, blue: 0.7019607843, alpha: 1)
        sc.searchBar.placeholder = "Search City"
        sc.searchBar.searchTextField.textColor = .white
        sc.searchBar.searchTextField.addTarget(self, action: #selector(moveSearchVC), for: .touchDown)
        sc.hidesNavigationBarDuringPresentation = false
        return sc
    }()
    
    // 도시 이름
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    // 기온
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 60)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    // 날씨
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    // 최고
    private let maxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    // 최저
    private let minLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 6, height: 100)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.4549019608, blue: 0.7019607843, alpha: 1)
        cv.layer.cornerRadius = 10
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWeather()
        fetchForecast()
        subscribeForecast()
    }
    
    
    
    func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3215686275, blue: 0.5843137255, alpha: 1)
        
        self.navigationItem.searchController = searchController
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        let verticalStackView = UIStackView(arrangedSubviews: [cityLabel, tempLabel, weatherLabel])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(20)
            $0.height.equalTo(150)
            $0.centerX.equalToSuperview()
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [maxLabel, minLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(verticalStackView.snp.bottom)
            $0.width.equalTo(150)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom).offset(30)
            $0.leading.equalTo(safeArea).offset(15)
            $0.trailing.equalTo(safeArea).offset(-15)
            $0.height.equalTo(150)
        }
    }
    
    func configureCollectionView() {
        collectionView.register(TopCell.self, forCellWithReuseIdentifier: "TopCell")
    }
    
    func fetchWeather() {
        guard let city = self.city else { return }
        guard let lon = lon else { return }
        guard let lat = lat else { return }
        
        viewModel.fetchWeather(lat: lat, lon: lon).subscribe(onNext: { weatherViewModels in
            self.weatherViewModel.accept(weatherViewModels)
            DispatchQueue.main.async {
                self.cityLabel.text = city
                self.tempLabel.text = weatherViewModels[0].temp
                self.weatherLabel.text = weatherViewModels[0].conditionName
                self.maxLabel.text = weatherViewModels[0].tempMax
                self.minLabel.text = weatherViewModels[0].tempMin
            }
        }).disposed(by: disposeBag)
        
    }
    
    func fetchForecast() {
        guard let lon = lon else { return }
        guard let lat = lat else { return }
        
        viewModel.fetchForecast(lat: lat, lon: lon).subscribe(onNext: { forecastViewModels in
            self.forecastViewModel.accept(forecastViewModels)
        }).disposed(by: disposeBag)
    }
    
    func subscribeForecast() {
        self.forecastViewModelObserver.subscribe(onNext: { forecast in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    
    @objc func moveSearchVC() {
        let searchVC = SearchViewController(viewModel: SearchViewModel())
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
        let forecastViewModel = self.forecastViewModel.value[indexPath.row]
        cell.viewModel.onNext(forecastViewModel)
        return cell
    }
}
