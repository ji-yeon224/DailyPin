//
//  RecordView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/05.
//

import UIKit

final class RecordView: BaseView {
    
    weak var textFieldDelegate: TextFieldProtocol?
    
    let scrollView = {
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
    
    
    
    let placeHolderLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.placeholderColor
        view.font = UIFont(name: "NanumGothic", size: 15)
        view.text = "record_writeRecord".localized()
        view.textAlignment = .left
        return view
    }()
    
    private let titleView = UIView()
    private let addressView = UIView()
    private let dateView = UIView()
    
    
    private let titleImage = {
        let view = UIImageView()
        view.image = Constants.Image.mappin
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    
    lazy var titleTextField = {
        let view = UITextField()
        view.font = UIFont(name: "NanumGothic", size: 15)
        view.textColor = Constants.Color.basicText
        view.tintColor = Constants.Color.mainColor
        view.contentVerticalAlignment = .center
        view.delegate = self
        
        return view
    }()
    
    var titleLabel = PlainLabel(size: 15, lines: 0)
    
    private let addressImageView = {
        let view = UIImageView()
        view.image = Constants.Image.selectPin
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    
    let addressLabel = PlainLabel(size: 13, lines: 0)
    
    private let dateImage = {
        let view = UIImageView()
        view.image = Constants.Image.calendar
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    
    
    var datePickerView = {
        let view = UIDatePicker()
        view.datePickerMode = .dateAndTime
        view.preferredDatePickerStyle = .compact
        view.backgroundColor = Constants.Color.background
        view.locale = Locale(identifier: Locale.current.languageCode ?? "ko_KR")
        view.tintColor = Constants.Color.mainColor
        return view
    }()
    

    var dateLabel = PlainLabel(size: 15, lines: 1)
    
    private let bottomView = UIView()
    
    lazy var memoTextView = {
        let view = MemoTextView()
        view.delegate = self
        view.font = UIFont(name: "NanumGothic", size: 15)
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        titleView.addSubview(titleImage)
        titleView.addSubview(titleTextField)
        titleView.addSubview(titleLabel)
        addressView.addSubview(addressImageView)
        addressView.addSubview(addressLabel)
        dateView.addSubview(dateImage)
        dateView.addSubview(datePickerView)
        dateView.addSubview(dateLabel)
        stackViewConfiguration()
        
        memoTextView.addSubview(placeHolderLabel)
        
        datePickerView.addTarget(self, action: #selector(dateChange), for: .valueChanged)
    }
    
    @objc private func dateChange() {
        
        dateLabel.text = DateFormatter.convertDate(date: datePickerView.date)
        
        
    }
    
    private func stackViewConfiguration() {
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(addressView)
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(memoTextView)
        
    }
    
    override func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
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
        
        
        datePickerView.snp.makeConstraints { make in
            make.leading.equalTo(dateImage.snp.trailing).offset(15)
            make.trailing.equalTo(dateView)
            make.height.equalTo(dateView)
        }
        
        dateLabel.snp.makeConstraints { make in
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
    
    private func setStackViewConstraints() {
        
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
        
    }
    
    func setEditMode() {
        memoTextView.isHidden = false
        memoTextView.isEditable = true
        setPickerView()
        setTitleLabel(true)
        if let memo = memoTextView.text, !memo.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
        
    }
    
    func setReadMode() {
        memoTextView.isEditable = false
        setDateLabel()
        placeHolderLabel.isHidden = true
        titleTextField.isHidden = true
        
        if let memo = memoTextView.text, memo.isEmpty || memoTextView.text == nil {
            memoTextView.isHidden = true
        } else {
            memoTextView.isHidden = false
        }
        setTitleLabel(false)
    }
    
    private func setTitleLabel(_ ishidden: Bool) {
        titleLabel.isHidden = ishidden
        titleTextField.isHidden = !ishidden
    }
   
    
    private func setDateLabel() {
        dateLabel.isHidden = false
        datePickerView.isHidden = true
    }
    
    func setPickerView() {
        dateLabel.isHidden = true
        datePickerView.isHidden = false
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
   
    
    
}


extension RecordView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text == "" {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
        
        setLineSpacing(text: textView.text)
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
    
    func setLineSpacing(text: String?) {
        guard let text = text else {
            return
        }
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let range = (text as NSString).range(of: text)
        let font = UIFont(name: "NanumGothic", size: 15) ?? .systemFont(ofSize: 15)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(.font, value: font, range: range)
        memoTextView.attributedText = attrString
    }
    
}

extension RecordView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 20 else {
            textFieldDelegate?.shouldChangeCharactersIn()
            return false
        }
        return true
    }
    
}
