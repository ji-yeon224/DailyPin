//
//  RecordWriteViewController.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class RecordWriteViewController: BaseViewController {
    
    private let mainView = RecordWriteView()
    private let viewModel = RecordWriteViewModel()
    private let disposeBag = DisposeBag()
    
    private var record: Record?
    private var location: PlaceItem?
    
    private let saveButtonTap = PublishRelay<Void>()
    private let backButtonTap = PublishRelay<Void>()
    private var recordMode: RecordMode = .create
    private var imgList: [SelectedImage] = []
//    private let imageModel = PublishRelay<[SelectImageModel]>()
    
//    private lazy var photoButton = UIBarButtonItem(image: Constants.Image.photo, style: .plain, target: self, action: nil)
    
//    private lazy var doneButton = UIBarButtonItem(image: Constants.Image.keyboardDown, style: .plain, target: self, action: nil)
    
    var longPressHandler: (() -> Void)?
    var updateRecord: ((Record) -> Void)?
    
    override func loadView() {
        self.view = mainView
    }
    
    init(mode: RecordMode, record: Record?, location: PlaceItem?) {
        super.init(nibName: nil, bundle: nil)
        self.record = record
        self.location = location
        self.recordMode = mode
    }
    
    deinit {
        debugPrint("writevc deinit")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
    }
    
    private func config() {
        setNavBar()
        setData()
        bindEvent()
        bind()
//        configToolBar()
//        mainView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        longPressHandler?()
    }
    
    private func setData() {
        guard let location = location else {
            dismiss(animated: true)
            return
        }
        mainView.titleTextField.becomeFirstResponder()
        
        mainView.addressLabel.text = location.address
        mainView.titleTextField.placeholder = location.name
        
        if let record = record {
            mainView.titleTextField.text = record.title
            mainView.datePickerView.date = record.date
            if let memo = record.memo {
                mainView.memoTextView.attributedText = memo.setLineSpacing()
                if !memo.isEmpty {
                    mainView.placeHolderLabel.isHidden = true
                } else {
                    mainView.placeHolderLabel.isHidden = false
                }
                
            } else {
                mainView.placeHolderLabel.isHidden = false
            }
            
            
        } else {
            mainView.datePickerView.date = Date()
        }
    }
    
}

extension RecordWriteViewController {
    private func bind() {
        let requestCreate = PublishRelay<(Record, PlaceItem)>()
        let requestUpdate = PublishRelay<(Record, Record)>()
        
        let input = RecordWriteViewModel.Input(createRecord: requestCreate, updateRecord: requestUpdate)
        let output = viewModel.transform(input: input)
        
        saveButtonTap
            .bind(with: self) { owner, _ in
                guard let newData = owner.getSaveRecordData(), let location = owner.location else {
                    owner.showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) { }
                    return
                }
                switch owner.recordMode {
                case .create:
                    requestCreate.accept((newData, location))
                case .update:
                    if let record = owner.record {
                        requestUpdate.accept((record, newData))
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        output.msg
            .asDriver(onErrorJustReturn: "")
            .filter { !$0.isEmpty }
            .drive(with: self) { owner, value in
                owner.showToastMessage(message: value)
            }
            .disposed(by: disposeBag)
        
        output.successMsg
            .bind(with: self) { owner, value in
                owner.showOKAlert(title: "", message: value) {
                    NotificationCenter.default.post(name: .updateCell, object: nil)
                    
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.updateData
            .bind(with: self) { owner, data in
                owner.showOKAlert(title: "", message: "toast_editComplete".localized()) {
                    NotificationCenter.default.post(name: .updateCell, object: nil)
                    owner.updateRecord?(data)
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func bindEvent() {
        
        
        view.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, value in
                if !owner.mainView.isEmptyText() {
                    owner.okDesctructiveAlert(title: "alert_alertEditModeTitle".localized(), message: "alert_alertEditModeMessage".localized()) {
                        owner.dismiss(animated: true)
                    } cancelHandler: {  }
                } else {
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.memoTextView.rx.text.changed
            .bind(with: self) { owner, value in
                owner.mainView.placeHolderLabel.isHidden = value != ""
                if let text = value {
                    owner.mainView.memoTextView.attributedText = text.setLineSpacing()
                }
                owner.mainView.scrollView.updateContentView()
            }
            .disposed(by: disposeBag)
        
        mainView.titleTextField.rx.text.changed
            .withLatestFrom(mainView.titleTextField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                if value.count >= 20 {
                    owner.showToastMessage(message: "record_titleLimit".localized())
                }
            }
            .disposed(by: disposeBag)
        
//        photoButton.rx.tap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .asDriver(onErrorJustReturn: ())
//            .drive(with: self) { owner, _ in
////                owner.configImageCell()
//                PHPickerManager.shared.presentPicker(vc: self, selectLimit: 2)
//            }
//            .disposed(by: disposeBag)
        
//        imageModel
//            .bind(to: mainView.imagePickCollectionView.rx.items(dataSource: mainView.dataSource))
//            .disposed(by: disposeBag)
        
//        PHPickerManager.shared.selectedImage
//            .bind(with: self) { owner, image in
//                owner.imgList.append(contentsOf: image.map { return SelectedImage(image: $0)})
//                
//                let data = SelectImageModel(section: "", items: owner.imgList)
//                owner.imageModel.accept([data])
//            }
//            .disposed(by: disposeBag)
    }
    
//    private func configImageCell() {
//        PHPickerManager.shared.presentPicker(vc: self, selectLimit: 2)
//        PHPickerManager.shared.selectedImage
//            .bind(with: self) { owner, image in
//                owner.imgList.append(contentsOf: image.map { return SelectedImage(image: $0)})
//                print(owner.imgList.count)
//                let data = SelectImageModel(section: "", items: owner.imgList)
//                owner.imageModel.accept([data])
//            }
//            .disposed(by: disposeBag)
//        
//    }
    
    private func getSaveRecordData() -> Record? {
        guard let location = location else {
            
            return nil
        }
        
        var title = mainView.titleTextField.text?.trimmingCharacters(in: .whitespaces) ?? location.name
        
        if title.isEmpty {
            title = location.name
        }
        
        return Record(title: title, date: mainView.datePickerView.date, memo: mainView.memoTextView.text)
    }
}

//extension RecordWriteViewController: ImageCollectionProtocol {
//    func cancelButtonTap(index: Int) {
//        imgList.remove(at: index)
//        let data = SelectImageModel(section: "", items: imgList)
//        imageModel.accept([data])
//    }
//    
//    
//}

extension RecordWriteViewController {
    @objc private func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = mainView.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 80
        mainView.scrollView.contentInset = contentInset
        mainView.scrollView.scrollIndicatorInsets = mainView.scrollView.contentInset
        
        UIView.animate(withDuration: 0.3,
                               animations: { self.view.layoutIfNeeded()},
                               completion: nil)
    }

    @objc private func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mainView.scrollView.contentInset = contentInset
    }
}

extension RecordWriteViewController {
    private func setNavBar() {
        
        switch recordMode {
        case .update:
            title = "updateText".localized()
        case .create:
            title = "createText".localized()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "saveButton".localized(), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.basicText
    }
    
    @objc private func saveButtonTapped() {
        saveButtonTap.accept(())
        
    }
    
//    private func configToolBar() {
//        
//        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        photoButton.tintColor = Constants.Color.basicText
//        doneButton.tintColor = Constants.Color.basicText
//        
//        mainView.toolbar.setItems([photoButton, flexibleSpaceButton, doneButton], animated: true)
//    }
}
