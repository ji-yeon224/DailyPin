//
//  RecordReadView.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import UIKit

final class RecordReadView: BaseView {
    
    let scrollView = UIScrollView(frame: .zero)
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 10
        
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: .zero, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    
    private let titleView = UIView()
    private let addressView = UIView()
    private let dateView = UIView()
    
    
    private let titleImage = BasicImageView(img: Constants.Image.mappin)
    var titleLabel = PlainLabel(size: 15, lines: 0)
    
    private let addressImageView = BasicImageView(img: Constants.Image.selectPin)
    let addressLabel = PlainLabel(size: 13, lines: 0)
    
    private let dateImage = BasicImageView(img: Constants.Image.calendar)
    var dateLabel = PlainLabel(size: 15, lines: 1)
    
    private let bottomView = UIView()
    
    lazy var memoTextView = MemoTextView().then {
        $0.font = Font.nanum.fontStyle//UIFont(name: "NanumGothic", size: 15)
        $0.isEditable = false
    }
    
    override func configureUI() {
        super.configureUI()
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [titleView, addressView, dateView, memoTextView].forEach {
            stackView.addArrangedSubview($0)
        }
        [titleImage, titleLabel].forEach {
            titleView.addSubview($0)
        }
        [addressImageView, addressLabel].forEach {
            addressView.addSubview($0)
        }
        [dateImage, dateLabel].forEach {
            dateView.addSubview($0)
        }

        
    }
    
    private func setMemoTextView() {
        if let memo = memoTextView.text, memo.isEmpty || memoTextView.text == nil {
            memoTextView.isHidden = true
        } else {
            memoTextView.isHidden = false
        }
    }
    
    func setRecordData(data: Record) {
//        addressLabel.text = location
        titleLabel.text = data.title
        dateLabel.text = DateFormatter.convertToString(format: .fullDateTime, date: data.date)
        if let memo = data.memo {
            memoTextView.attributedText = memo.setLineSpacing()
        }
        setMemoTextView()
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
        titleLabel.snp.makeConstraints { make in
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
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateImage.snp.trailing).offset(15)
            make.trailing.equalTo(dateView)
            make.height.equalTo(dateView)
        }
        
    }
}
