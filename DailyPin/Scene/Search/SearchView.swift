//
//  SearchView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/28.
//

import UIKit

final class SearchView: BaseView {
    
    weak var collectionViewDelegate: CollectionViewProtocol?
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = LocalizableKey.searchPlaceholder.localized
        view.backgroundColor = Constants.Color.background
        view.searchTextField.backgroundColor = .clear
        view.searchTextField.textColor = Constants.Color.basicText
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.keyboardDismissMode = .onDrag
        view.backgroundColor = Constants.Color.background
        view.delegate = self
        view.isHidden = false
        return view
    }()
    
    private let googleImage = {
        let view = UIImageView()
        view.image = Constants.Image.google
        view.contentMode = .scaleAspectFit
        return view
    }()

    var dataSource: UICollectionViewDiffableDataSource<Int, PlaceItem>!
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(collectionView)
        addSubview(googleImage)
        
        configureDataSource()
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        googleImage.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let screenWidth = UIScreen.main.bounds.width
        let estimatedHeight = NSCollectionLayoutDimension.estimated(screenWidth)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 5
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, PlaceItem> { cell, indexPath, itemIdentifier in
            cell.title.text = itemIdentifier.name
            cell.address.text = itemIdentifier.address
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
    
    
}

extension SearchView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionViewDelegate?.didSelectPlaceItem(item: nil)
            return
        }
        collectionViewDelegate?.didSelectPlaceItem(item: item)
    }
    
}
