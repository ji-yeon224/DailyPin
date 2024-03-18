//
//  RecordWriteView.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import UIKit
import RxDataSources
import RxCocoa

final class RecordWriteView: BaseView {
    let scrollView = UIScrollView(frame: .zero)
    
    weak var delegate: ImageCollectionProtocol?
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 10
        
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: .zero, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let placeHolderLabel = UILabel().then {
        $0.textColor = Constants.Color.placeholderColor
        $0.font = Font.nanum.fontStyle //UIFont(name: "NanumGothic", size: 15)
        $0.text = "record_writeRecord".localized()
        $0.textAlignment = .left
    }
    
    private let titleView = UIView()
    private let addressView = UIView()
    private let dateView = UIView()
    
    private let titleImage = BasicImageView(img: Constants.Image.mappin)
    lazy var titleTextField = UITextField().then{
        $0.font = Font.nanum.fontStyle //UIFont(name: "NanumGothic", size: 15)
        $0.textColor = Constants.Color.basicText
        $0.tintColor = Constants.Color.mainColor
        $0.contentVerticalAlignment = .center
        $0.delegate = self
        
    }
    
    private let addressImageView = BasicImageView(img: Constants.Image.selectPin)
    let addressLabel = PlainLabel(size: 13, lines: 0)
    
    private let dateImage = BasicImageView(img: Constants.Image.calendar)
    var datePickerView = UIDatePicker().then {
        $0.datePickerMode = .dateAndTime
        $0.preferredDatePickerStyle = .compact
        $0.backgroundColor = Constants.Color.background
        $0.locale = Locale(identifier: Locale.current.languageCode ?? "ko_KR")
        $0.tintColor = Constants.Color.mainColor
    }
    private let bottomView = UIView()
    
    lazy var memoTextView = MemoTextView().then {
        $0.font = Font.nanum.fontStyle//UIFont(name: "NanumGothic", size: 15)
    }
    
    let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100))
    
    private var imgBackView = UIView()
    lazy var imagePickCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return view
    }()
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SelectImageModel>!
    
    private func configDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SelectImageModel> { dataSource, imagePickCollectionView, indexPath, item in
            guard let cell = imagePickCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            cell.imageView.image = item.image.resize(width: 50)
            cell.cancelButton.rx.tap
                .asDriver()
                .drive(with: self, onNext: { owner, _ in
                    owner.delegate?.cancelButtonTap(index: indexPath.item)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
    
    
    
    override func configureUI() {
        super.configureUI()
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [titleView, addressView, dateView, memoTextView].forEach {
            stackView.addArrangedSubview($0)
        }
        [titleImage, titleTextField].forEach {
            titleView.addSubview($0)
        }
        [addressImageView, addressLabel].forEach {
            addressView.addSubview($0)
        }
        [dateImage, datePickerView].forEach {
            dateView.addSubview($0)
        }
        memoTextView.addSubview(placeHolderLabel)
        addSubview(toolbar)
        
        addSubview(imagePickCollectionView)
        configDataSource()
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        titleView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width).inset(20)
            make.height.equalTo(44)
        }
        addressView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width).inset(20)
            make.height.equalTo(50)
        }
        
        dateView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width).inset(20)
            make.height.equalTo(44)
        }
        
        titleImage.snp.makeConstraints { make in
            make.leading.equalTo(titleView)
            make.centerY.equalTo(titleView)
            make.width.equalTo(titleView).multipliedBy(0.08)
            make.height.equalTo(titleImage.snp.width).multipliedBy(1.0)
            
        }
        
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleImage.snp.trailing).offset(15)
            make.trailing.equalTo(titleView)
            make.height.equalTo(titleView)
        }
        
        addressImageView.snp.makeConstraints { make in
            make.leading.equalTo(addressView)
            make.centerY.equalTo(addressView)
            make.width.equalTo(addressView).multipliedBy(0.08)
            make.height.equalTo(titleImage.snp.width).multipliedBy(1.0)
        }
        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(addressImageView.snp.trailing).offset(15)
            make.trailing.equalTo(addressView)
            make.height.equalTo(addressView)
        }
        
        dateImage.snp.makeConstraints { make in
            make.leading.equalTo(dateView)
            make.centerY.equalTo(dateView)
            make.width.equalTo(dateView).multipliedBy(0.08)
            make.height.equalTo(dateImage.snp.width).multipliedBy(1.0)
        }
        
        
        datePickerView.snp.makeConstraints { make in
            make.leading.equalTo(dateImage.snp.trailing).offset(15)
            make.trailing.equalTo(dateView)
            make.height.equalTo(dateView)
        }
        
        placeHolderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(memoTextView)
            make.leading.equalTo(memoTextView).offset(30)
            make.width.equalTo(memoTextView)
            make.height.equalTo(30)
        }
        
        imagePickCollectionView.snp.makeConstraints { make in
            make.width.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(toolbar.snp.top)
            make.height.equalTo(80)
        }
        
        toolbar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
    }
    
    func isEmptyText() -> Bool {
        
        guard let title = titleTextField.text, let memo = memoTextView.text else {
            
            return true
        }
        
        if title.trimmingCharacters(in: .whitespaces).isEmpty && memo.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        
        return false
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        let size = UIScreen.main.bounds.width - 40 //self.frame.width - 40
        layout.itemSize = CGSize(width: size / 5, height: size / 5)
        return layout
    }
    
}

extension RecordWriteView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 20 else {
            return false
        }
        return true
    }
    
}
