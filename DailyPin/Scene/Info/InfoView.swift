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
        
        view.delegate = self 
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
        view.tintColor = Constants.Color.subTextColor
        view.contentMode = .scaleAspectFit
        view.image = Constants.Image.warning
        return view
    }()
    
    private let errorLabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textColor = Constants.Color.subTextColor
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    
    
    
    override func configureUI() {
        super.configureUI()
        addSubview(uiView)
        uiView.addSubview(titleLabel)
        uiView.addSubview(addButton)
        uiView.addSubview(addressLabel)
        addSubview(collectionView)
        addSubview(errorView)
        errorView.addSubview(errorImage)
        errorView.addSubview(errorLabel)
        configureDataSource()
    }
    
    override func setConstraints() {
        uiView.backgroundColor = Constants.Color.background
        uiView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
            make.height.equalTo(150)
            
        }
        
        setUIVIewContentsConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(uiView.snp.bottom).offset(30)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        setErrorViewConstraints()
        
    }
    
    private func setErrorViewConstraints() {
        errorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(uiView.snp.bottom).offset(50)
            make.height.equalTo(50)
            
        }
        errorImage.snp.makeConstraints { make in
            make.top.equalTo(errorView)
            make.centerX.equalTo(errorView)
            make.width.equalTo(errorView.snp.width).multipliedBy(0.3)
            make.height.equalTo(errorImage.snp.width)
            
        }
        
        errorLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(errorView)
            make.top.equalTo(errorImage.snp.bottom).offset(10)
            make.bottom.greaterThanOrEqualTo(errorView).offset(10)
        }
        
        
    }
    
    func errorViewHidden(error: Bool) {
        errorView.isHidden = error
        collectionView.isHidden = !error
    }
    
//    func configureHidden(collection: Bool, error: Bool) {
//
//        collectionView.isHidden = collection
//        errorView.isHidden = error
//    }
    
    func configureErrorView(image: UIImage?, description: String) {
        
        errorImage.image = image ?? Constants.Image.warning
        errorLabel.text = description
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
        
        let screenWidth = UIScreen.main.bounds.width
        let estimatedHeight = NSCollectionLayoutDimension.estimated(screenWidth)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 5
        
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Record> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            cell.dateLabel.text = DateFormatter.convertDate(date: itemIdentifier.date)
            cell.address.isHidden = true
            
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
