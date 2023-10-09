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
        view.backgroundColor = Constants.Color.background
        view.searchTextField.backgroundColor = .clear
        view.searchTextField.textColor = Constants.Color.basicText
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.keyboardDismissMode = .onDrag
        view.backgroundColor = Constants.Color.background
        view.delegate = self
        view.isHidden = false
        return view
    }()
    
    private let errorView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private let errorImage = {
        let view = UIImageView()
        view.image = Image.ImageName.networkError
        view.tintColor = Constants.Color.subTextColor
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let networkErrorLabel = {
        let view = UILabel()
        view.text = "네트워크 연결을 확인해주세요."
        view.backgroundColor = .clear
        view.textColor = Constants.Color.subTextColor
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, PlaceElement>!
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(collectionView)
        addSubview(errorView)
        errorView.addSubview(errorImage)
        errorView.addSubview(networkErrorLabel)
        
        
        configureDataSource()
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setErrorViewConstraints()
    }
    
    private func setErrorViewConstraints() {
        errorView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(50)
            
        }
        errorImage.snp.makeConstraints { make in
            make.top.equalTo(errorView)
            make.centerX.equalTo(errorView)
            make.width.equalTo(errorView.snp.width).multipliedBy(0.4)
            make.height.equalTo(errorImage.snp.width)
            
        }
        
        networkErrorLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(errorView)
            make.top.equalTo(errorImage.snp.bottom).offset(10)
            make.bottom.greaterThanOrEqualTo(errorView).offset(10)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(75))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 5
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SearchCollectionViewCell, PlaceElement> { cell, indexPath, itemIdentifier in
            cell.title.text = itemIdentifier.displayName.placeName
            cell.address.text = itemIdentifier.formattedAddress
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
    }
    
    func configureHidden(collection: Bool, network: Bool) {
        collectionView.isHidden = collection
        errorView.isHidden = network
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
