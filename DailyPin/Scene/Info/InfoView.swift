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
    
    private lazy var topView = UIView()
    private lazy var stackView = UIStackView(frame: .zero).then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    var titleLabel = BasicTextLabel(style: .bodyLarge)
    
    var addressLabel = BasicTextLabel(style: .body, color: Constants.Color.subTextColor)

    let addButton = CustomImageButton(img: Constants.Image.addRecord)
    private let divider = DividerView()
    
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
        [stackView, addButton, collectionView].forEach {
            addSubview($0)
        }
        [titleLabel, addressLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        configureDataSource()
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(addButton.snp.leading).offset(-10)
            
        }
        addButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(30)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
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
