//
//  MainViewController.swift
//  Test
//
//  Created by 이상준 on 2023/01/11.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit

class SearchViewController: UIViewController {
    
    let viewModel: SearchViewModel
    let disposeBag = DisposeBag()
    
    var cityViewModel = BehaviorRelay<[CityViewModel]>(value: [])
    var cityViewModelObserver: Observable<[CityViewModel]> {
        return cityViewModel.asObservable()
    }
    
    var filterCityArray: [CityViewModel] = []
    
    // 검색중인지 확인하기 위한 변수
    var isFiltering: Bool {
         let searchController = self.navigationItem.searchController
         let isActive = searchController?.isActive ?? false
         let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
         return isActive && isSearchBarHasText
     }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.4549019608, blue: 0.7019607843, alpha: 1)
        sc.searchBar.placeholder = "Search City"
        sc.searchBar.searchTextField.textColor = .white
        sc.hidesNavigationBarDuringPresentation = false
        return sc
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3215686275, blue: 0.5843137255, alpha: 1)
        tv.separatorColor = .white
        tv.separatorInset.right = 20
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        fetchCitys()
        subscribe()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    func configureUI() {
        let safeArea = self.view.safeAreaLayoutGuide
        view.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3215686275, blue: 0.5843137255, alpha: 1)

        self.navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeArea)
        }
        
    }
    
    func configureTableView() {
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: "CityCell")
    }
    
    func fetchCitys() {
        viewModel.fetchCitys().subscribe(onNext: { cityViewModels in
            self.cityViewModel.accept(cityViewModels)
        }).disposed(by: disposeBag)
    }
    
    func subscribe() {
        self.cityViewModelObserver.subscribe(onNext: { citys in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
}

// MARK: - 테이블 뷰 데이터소스, 델리게이트 구현
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filterCityArray.count : self.cityViewModel.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! SearchCell
        cell.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.3215686275, blue: 0.5843137255, alpha: 1)
        if self.isFiltering {
            let filterCityViewModel = self.filterCityArray[indexPath.row]
            cell.viewModel.onNext(filterCityViewModel)
        } else {
            let cityViewModel = self.cityViewModel.value[indexPath.row]
            cell.viewModel.onNext(cityViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainVC = self.navigationController?.viewControllers[0] as! MainViewController
        if self.isFiltering {
            mainVC.city = self.filterCityArray[indexPath.row].name
            mainVC.lon = self.filterCityArray[indexPath.row].lon
            mainVC.lat = self.filterCityArray[indexPath.row].lat
        } else {
            mainVC.city = self.cityViewModel.value[indexPath.row].name
            mainVC.lon = self.cityViewModel.value[indexPath.row].lon
            mainVC.lat = self.cityViewModel.value[indexPath.row].lat
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.filterCityArray = self.cityViewModel.value.filter { $0.name!.lowercased().hasPrefix(text) }
        self.tableView.reloadData()
    }
}
