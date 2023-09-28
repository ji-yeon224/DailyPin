//
//  SearchView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import UIKit

final class SearchView: BaseView {
    
    let searchBar = SearchBar()
    
    override func configureUI() {
        super.configureUI()
        searchBar.placeholder = "장소 검색"
        
    }
    
    override func setConstraints() {
        
    }
    
}
