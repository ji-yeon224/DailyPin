//
//  SearchViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import UIKit
import Network
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private let viewModel = SearchViewModel()
    
    private let monitor = NWPathMonitor()
    
    private var centerLocation: (Double, Double) = (0, 0)
    weak var delegate: SearchResultProtocol?
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        mainView.collectionViewDelegate = self
        self.view = mainView
        
    }
    
    init(location: (Double, Double)) {
        super.init(nibName: nil, bundle: nil)
        centerLocation = location
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.searchBar
        mainView.searchBar.becomeFirstResponder()
        
        bindData()
    }
    
    override func configureUI() {
        super.configureUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    
    private func updateSnapShot(item: [PlaceItem]) {
        var snapShot = NSDiffableDataSourceSnapshot<Int, PlaceItem>()
        snapShot.appendSections([0])
        snapShot.appendItems(item)
        mainView.dataSource.apply(snapShot)
    }
}

// - MARK: Binding
extension SearchViewController {
    
    private func bindData() {
        
        viewModel.searchResult
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, result in
                owner.updateSnapShot(item: result)
            }
            .disposed(by: disposeBag)
        
        viewModel.searchError
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                owner.showToastMessage(message: value)
            }
            .disposed(by: disposeBag)
        
        NetworkMonitor.shared.connected
            .bind(with: self) { owner, isConnected in
                if !isConnected { //연결 안됨
                    owner.showToastMessage(message: "network_connectError".localized())
                }
            }
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                if text.count == 0 {
                    owner.viewModel.removeSearchResult()
                }
            }
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.searchButtonClicked
            .withLatestFrom(mainView.searchBar.rx.text.orEmpty) { _, value in
                return value
            }
            .bind(with: self) { owner, text in
                if text.count <= 0 {
                    owner.showToastMessage(message: "error_emptySearchResult".localized())
                } else {
                    owner.viewModel.callPlaceRequest(query: text, langCode: .ko, location: owner.centerLocation)
                    owner.view.endEditing(true)
                }
            }
            .disposed(by: disposeBag)
            
            
        
    }
}

extension SearchViewController: CollectionViewProtocol {
    
    func didSelectPlaceItem(item: PlaceItem?) {
        guard let item = item else {
            showToastMessage(message: "toast_errorAlert".localized())
            return
        }
        
//        selectLocationHandler?(item)
        delegate?.selectSearchResult(place: item)
        dismiss(animated: true)
        
    }
    
}


