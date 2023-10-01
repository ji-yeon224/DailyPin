//
//  SearchTextField.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/27.
//

import UIKit

final class SearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        backgroundColor = Constants.Color.background
        layer.cornerRadius = 10
        searchTextField.backgroundColor = .clear
        setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    }
  
}
