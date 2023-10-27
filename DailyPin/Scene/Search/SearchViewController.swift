//
//  SearchViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import UIKit
import Network

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private let viewModel = SearchViewModel()
    
    private let monitor = NWPathMonitor()
    var selectLocationHandler: ((PlaceElement) -> Void)?
    var centerLocation: (Double, Double) = (0, 0)
    
    override func loadView() {
        mainView.collectionViewDelegate = self
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.searchBar
        mainView.searchBar.becomeFirstResponder()
        mainView.searchBar.delegate = self
        bindData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkConfiguration), name: .networkConnect, object: nil)
        
        
       
    }
    
    @objc private func networkConfiguration(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        if let value = userInfo["isConnected"] as? Bool {
            if value {
                DispatchQueue.main.async {
                    self.mainView.configureHidden(collection: false, error: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.mainView.configureHidden(collection: true, error: false)
                }
            }
        }
        
        
    }
    
    private func bindData() {
        
        viewModel.searchResult.bind { [weak self] data in
            self?.updateSnapShot()
        }
        
        viewModel.resultError.bind { [weak self] data in
            guard let data = data else { return }
            self?.viewModel.removeSearchResult()
            self?.showToastMessage(message: data)
        }
    }
    
    
    override func configureUI() {
        super.configureUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        if NetworkMonitor.shared.isConnected {
            self.mainView.configureHidden(collection: false, error: true)
            self.mainView.configureErrorView(image: Constants.Image.networkError, description: "network_connectError".localized())
        } else {
            self.mainView.configureHidden(collection: true, error: false)
        }
        
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, PlaceElement>()
        snapShot.appendSections([0])
        snapShot.appendItems(viewModel.searchResult.value.places)
        mainView.dataSource.apply(snapShot)
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces), !query.isEmpty else {
            mainView.configureErrorView(image: Constants.Image.noData, description: "error_emptySearchResult".localized())
            mainView.configureHidden(collection: true, error: false)
            return
        }
        
        viewModel.callPlaceRequest(query: query, langCode: .ko, location: centerLocation)
        mainView.configureHidden(collection: false, error: true)
        view.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" && viewModel.searchResult.value.places.count > 0 {
            viewModel.removeSearchResult()
        }
    }
    
}

extension SearchViewController: CollectionViewProtocol {
    
    func didSelectPlaceItem(item: PlaceElement?) {
        guard let item = item else {
            showToastMessage(message: "toast_errorAlert".localized())
            return
        }
        
        selectLocationHandler?(item)
        
        dismiss(animated: true)
        
    }
    
}


