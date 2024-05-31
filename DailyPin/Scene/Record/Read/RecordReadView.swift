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
    
    
    private var titleLabel = BasicTextLabel(style: .title1)
    
    private let addressLabel = BasicTextLabel(style: .body, lines: 0)
    
    private var dateLabel = BasicTextLabel(style: .body)
    
    private let bottomView = UIView()
    
    private lazy var memoTextView = MemoTextView(mode: .read)
    private let divider  = UIView().then {
        $0.backgroundColor = Constants.Color.mainColor
    }
    override func configureUI() {
        super.configureUI()
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [titleView, addressView, dateView, divider, memoTextView].forEach {
            stackView.addArrangedSubview($0)
        }
        [titleLabel].forEach {
            titleView.addSubview($0)
        }
        [addressLabel].forEach {
            addressView.addSubview($0)
        }
        [dateLabel].forEach {
            dateView.addSubview($0)
        }

        
    }
    
    private func setMemoTextView() {
        if let memo = memoTextView.text, memo.isEmpty || memoTextView.text == nil {
            memoTextView.isHidden = true
            divider.isHidden = true
        } else {
            memoTextView.isHidden = false
            divider.isHidden = false
        }
    }
    
    func setRecordData(data: Record, address: String) {
        titleLabel.text = data.title
        dateLabel.text = DateFormatter.convertToString(format: .fullDateTime, date: data.date)
        if let memo = data.memo {
            memoTextView.attributedText = memo.setLineSpacing()
        }
        addressLabel.text = address
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
            make.height.equalTo(30)
        }
        addressView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width).inset(20)
            make.height.equalTo(25)
        }
        
        dateView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width).inset(20)
            make.height.equalTo(25)
        }
        divider.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width).inset(20)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleView)
            make.trailing.equalTo(titleView)
            make.height.equalTo(titleView)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(addressView)
            make.trailing.equalTo(addressView)
            make.height.equalTo(addressView)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateView)
            make.trailing.equalTo(dateView)
            make.height.equalTo(dateView)
        }
        
    }
}
