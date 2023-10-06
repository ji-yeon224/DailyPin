//
//  RecordView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import UIKit

class RecordView: BaseView {
    
    private let scrollView = {
        let view = UIScrollView()
        view.updateContentView()
        return view
    }()
    
    private let stackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 10
        
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: .zero, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    
    
    private let placeHolderLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.placeholderColor
        view.font = .systemFont(ofSize: 15)
        view.text = "record_writeRecord".localized()
        view.textAlignment = .left
        return view
    }()
    
    private let titleView = UIView()
    private let dateView = UIView()
    
    
    private let titleImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "mappin.circle")
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    
    var titleTextField = {
        let view = UITextField()
        view.placeholder = "record_writeTitle".localized()
        view.tintColor = Constants.Color.mainColor
        view.contentVerticalAlignment = .center
        return view
    }()
    
    private let dateImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "calendar")
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    
    let datePicker = UIDatePicker()
    
    let datePikcerView = {
        let view = UIDatePicker()
        view.datePickerMode = .dateAndTime
        view.preferredDatePickerStyle = .compact
        view.backgroundColor = Constants.Color.background
        view.locale = Locale(identifier: "ko-KR")
        view.tintColor = Constants.Color.mainColor
        
        
        return view
    }()
    
//    lazy var dateTextField = {
//        let view = UITextField()
//        view.font = .systemFont(ofSize: 13, weight: .bold)
//        view.contentVerticalAlignment = .center
//        view.delegate = self
//        view.tintColor = .clear
//        return view
//    }()
    
    let bottomView = UIView()
    
    lazy var memoTextView = {
        let view = MemoTextView()
        view.delegate = self
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        titleView.addSubview(titleImage)
        titleView.addSubview(titleTextField)
        dateView.addSubview(dateImage)
        dateView.addSubview(datePikcerView)
        stackViewConfiguration()
        
        memoTextView.addSubview(placeHolderLabel)
    }
    
    private func stackViewConfiguration() {
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(memoTextView)
        stackView.addArrangedSubview(bottomView)
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(10)
        }
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        setStackViewConstraints()
        
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
        
        
        dateImage.snp.makeConstraints { make in
            make.leading.equalTo(dateView)
            make.centerY.equalTo(dateView)
            make.width.equalTo(dateView).multipliedBy(0.08)
            make.height.equalTo(dateImage.snp.width).multipliedBy(1.0)
        }
        
        
        datePikcerView.snp.makeConstraints { make in
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
        
        
        
    }
    
    func setStackViewConstraints() {
        
        titleView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        dateView.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.equalTo(stackView)
        }
    }
    
    
   
    
    
   
    
    
}

extension RecordView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
        
        let size = CGSize(width: stackView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            
            if estimatedSize.height <= 180 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
        
        scrollView.updateContentView()
    }
    
}

extension RecordView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
