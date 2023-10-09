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
        
       
    }
    
    private func bindData() {
        
        viewModel.searchResult.bind { data in
            self.updateSnapShot()
        }
        
        viewModel.resultError.bind { data in
            guard let data = data else { return }
            self.viewModel.removeSearchResult()
            self.showToastMessage(message: data)
        }
    }
    
    
    override func configureUI() {
        super.configureUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, PlaceElement>()
        snapShot.appendSections([0])
        snapShot.appendItems(viewModel.searchResult.value.places)
        mainView.dataSource.apply(snapShot)
    }
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            showToastMessage(message: "toast_searchInputError".localized())
            return
        }
        startMonitoring(query: query, langCode: .ko)
        //viewModel.callPlaceRequest(query: query, langCode: .ko, location: centerLocation)
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


// 네트워크 모니터링
extension SearchViewController {
    
    
    private func startMonitoring(query: String, langCode: LangCode) {

        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                
                DispatchQueue.main.async {
                    self.viewModel.callPlaceRequest(query: query, langCode: .ko, location: self.centerLocation)
                    self.mainView.configureHidden(collection: false, network: true)
                }
                return

            } else {
                DispatchQueue.main.async {
                    self.mainView.configureHidden(collection: true, network: false)

                }
            }

        }
    }

}
