//
//  PlaceListView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import UIKit
import SnapKit

final class PlaceListView: BaseView {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Place>!
    weak var collectionViewDelegate: PlaceCollectionViewProtocol?
    
    private let titleLabel = {
        let view = UILabel()
        view.text = "나의 장소"
        view.font = UIFont(name: "NanumGothicBold", size: 16)
        view.numberOfLines = 1
        view.textColor = Constants.Color.basicText
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.backgroundColor = Constants.Color.background
        view.contentInset = .init(top: 10, left: 0, bottom: 0, right: 0)
        view.delegate = self
        return view
    }()
    
    override func configureUI() {
        [titleLabel, collectionView].forEach {
            addSubview($0)
        }
        configureDataSource()
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    
}

extension PlaceListView {
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 10
        
        
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, Place> { cell, indexPath, itemIdentifier in
            cell.title.text = itemIdentifier.placeName
            cell.address.text = itemIdentifier.address
            cell.layoutIfNeeded()
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
}

extension PlaceListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionViewDelegate?.didSelectPlaceItem(item: nil)
            return
        }
        collectionViewDelegate?.didSelectPlaceItem(item: item)
    }
    
}
