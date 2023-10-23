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
        view.text = "myRecord".localized()
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
    
    private let placeHolderView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let placeHolderImageView = {
        let view = UIImageView()
        view.image = Constants.Image.noPlaceList
        view.contentMode = .scaleAspectFit
        view.tintColor = Constants.Color.placeholderColor
        return view
    }()
    
    private let placeHolderLabel = {
        let view = UILabel()
        view.text = "placeHolder_noPlaceList".localized()
        view.font =  UIFont(name: "NanumGothic", size: 14)
        view.textColor = Constants.Color.placeholderColor
        view.numberOfLines = 2
        view.textAlignment = .center
        return view
    }()
    
    override func configureUI() {
        [titleLabel, collectionView, placeHolderView].forEach {
            addSubview($0)
        }
        [placeHolderImageView, placeHolderLabel].forEach {
            placeHolderView.addSubview($0)
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
        
        placeHolderView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(100)
        }
        setPlaceHolderConstraints()
    }
    
    private func setPlaceHolderConstraints() {
        placeHolderImageView.snp.makeConstraints { make in
            make.top.equalTo(placeHolderView).offset(10)
            make.centerX.equalTo(placeHolderView)
            make.width.equalTo(placeHolderView.snp.width).multipliedBy(0.1)
            make.height.equalTo(placeHolderImageView.snp.width).multipliedBy(1)
        }
        placeHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(placeHolderImageView.snp.bottom).offset(10)
            make.centerX.equalTo(placeHolderView)
            make.horizontalEdges.equalTo(placeHolderView).inset(30)
            make.bottom.greaterThanOrEqualTo(placeHolderView.snp.bottom).offset(-20)
        }
    }
    
    func setPlaceHolder(_ data: Bool) {
        placeHolderView.isHidden = data
        collectionView.isHidden = !data
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
