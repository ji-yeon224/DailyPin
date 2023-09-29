//
//  SearchViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private let viewModel = SearchViewModel()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = mainView.searchBar
        mainView.searchBar.becomeFirstResponder()
        mainView.searchBar.delegate = self
        
    }
    
    
    override func configureUI() {
        super.configureUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    @objc private func backButtonClicked() {
        dismiss(animated: true)
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            // error alert
            return
        }
        
        viewModel.callPlaceRequest(query: query, langCode: .ko)
        
    }
    
}
