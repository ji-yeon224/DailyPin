//
//  InfoView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit



final class InfoView: BaseView {
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Record>!
    weak var collectionViewDelegate: RecordCollectionViewProtocol?
    
    private lazy var uiView = UIView()
    
    var titleLabel = CustomBasicLabel(text: "", fontType: Font.bodyLarge)
    
    var addressLabel = CustomBasicLabel(text: "", fontType: .body, color: Constants.Color.subTextColor)

    let addButton = CustomImageButton(img: Constants.Image.addRecord)

    // 저장된 목록 보여주기 
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.backgroundColor = Constants.Color.background
        view.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        view.delegate = self 
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
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
            make.height.equalTo(130)
            
        }
        
        setUIVIewContentsConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.top.equalTo(uiView.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
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
            make.top.equalTo(uiView).inset(37)
            make.trailing.equalTo(uiView).inset(20)
            make.size.equalTo(30)
//            make.height.equalTo(addButton.snp.width)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(uiView).inset(16)
            make.height.equalTo(40)
        }
    }
    
}


// collection view
extension InfoView {
    
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        //layout.configuration.interSectionSpacing = 10
        
        
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Record> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            cell.dateLabel.text = DateFormatter.convertToString(format: .fullDateTime, date: itemIdentifier.date)
            cell.address.isHidden = true
            cell.layoutIfNeeded()
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
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
