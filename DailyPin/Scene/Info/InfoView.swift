//
//  InfoView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit

struct Test: Hashable {
    var title: String
    var date: String
    
}

final class InfoView: BaseView {
    
    var testData = [Test(title: "aa", date: "11"), Test(title: "bb", date: "22")]
    var dataSource: UICollectionViewDiffableDataSource<Int, Test>!
    
    private let uiView = UIView()
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.basicText
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 23)
        return view
    }()
    
    var addressLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subTextColor
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 13)
        return view
    }()

    let addButton = AddButton()

    // 저장된 목록 보여주기 
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.backgroundColor = Constants.Color.background
        

        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        addSubview(uiView)
        uiView.addSubview(titleLabel)
        uiView.addSubview(addButton)
        uiView.addSubview(addressLabel)
        addSubview(collectionView)
        configureDataSource()
    }
    
    override func setConstraints() {
        uiView.backgroundColor = Constants.Color.background
        uiView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        
        setUIVIewContentsConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.top.equalTo(uiView.snp.bottom).offset(50)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        
        
    }
    
    private func setUIVIewContentsConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(uiView).offset(35)
            make.leading.equalTo(uiView).inset(16)
            make.height.equalTo(40)
            
        }
        
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(uiView).inset(35)
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.width.equalTo(uiView.snp.width).multipliedBy(0.08)
            make.height.equalTo(addButton.snp.width).multipliedBy(1)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(uiView).inset(16)
            make.height.equalTo(50)
        }
    }
    
}


// collection view
extension InfoView {
    
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(65))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 5
        
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Test> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            cell.dateLabel.text = itemIdentifier.date
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Test>()
        snapShot.appendSections([0])
        snapShot.appendItems(testData)
        dataSource.apply(snapShot)
    }
}
