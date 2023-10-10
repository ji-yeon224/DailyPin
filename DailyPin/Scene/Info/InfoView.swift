//
//  InfoView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit



final class InfoView: BaseView {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Record>!
    weak var collectionViewDelegate: InfoCollectionViewProtocol?
    
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
        view.isHidden = true
        view.delegate = self 
        return view
    }()
    
    
    
    let noDataLabel = {
        let view = UILabel()
        view.text = "아직 등록된 기록이 없습니다.\n 기록을 등록해보세요!"
        
        
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        addSubview(uiView)
        uiView.addSubview(titleLabel)
        uiView.addSubview(addButton)
        uiView.addSubview(addressLabel)
        addSubview(collectionView)
        addSubview(noDataLabel)
        configureDataSource()
    }
    
    override func setConstraints() {
        uiView.backgroundColor = Constants.Color.background
        uiView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
            make.height.equalTo(100)
        }
        
        setUIVIewContentsConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(uiView.snp.bottom).offset(50)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.top.equalTo(uiView.snp.bottom).offset(30)
            make.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(30)
        }
        
    }
    
    private func setUIVIewContentsConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(uiView).offset(35)
            make.leading.equalTo(uiView).offset(16)
            make.trailing.equalTo(addButton.snp.leading).offset(-10)
            make.height.equalTo(40)
            
        }
        
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(uiView).inset(35)
            //make.leading.equalTo(titleLabel.snp.trailing)
            make.width.equalTo(uiView.snp.width).multipliedBy(0.08)
            make.height.equalTo(addButton.snp.width)
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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 5
        
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Record> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            cell.dateLabel.text = DateFormatter.convertDate(date: itemIdentifier.date)
            
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func configureHidden(collView: Bool) {
        collectionView.isHidden = collView
        noDataLabel.isHidden = !collView
        
    }
    
    
}

extension InfoView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionViewDelegate?.didSelectRecordItem(item: nil)
            return
        }
        
        collectionViewDelegate?.didSelectRecordItem(item: item)
        
    }
    
}
