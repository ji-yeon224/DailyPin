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
        view.placeholder = "장소 검색"
        return view
    }()
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.keyboardDismissMode = .onDrag
        view.delegate = self
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, PlaceElement>!
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(collectionView)
        
        configureDataSource()
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, PlaceElement> { cell, indexPath, itemIdentifier in
            cell.title.text = itemIdentifier.displayName.text
            cell.address.text = itemIdentifier.formattedAddress
            
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
            collectionViewDelegate?.didSelectItem(item: nil)
            return
        }
        collectionViewDelegate?.didSelectItem(item: item)
    }
    
}
