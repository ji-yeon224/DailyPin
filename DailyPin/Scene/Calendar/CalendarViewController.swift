//
//  CalendarViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import UIKit
import RxSwift
import RxCocoa

final class CalendarViewController: BaseViewController {
    
    private let mainView = CalendarView()
    private let viewModel = CalendarViewModel()
    private var dateList: [Date] = []
    private var selectedDate = Date()
    private let requestDayRecord = BehaviorRelay<Date>(value: Date())
    private let requestMonthData = PublishSubject<Date?>()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    deinit {
        debugPrint("calendarview deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.calendarDelegate = self
        
        navigationController?.navigationBar.isHidden = false
        bindData()
        
        requestDayRecord.accept(selectedDate)
        requestMonthData.onNext(nil)
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    
    override func configureUI() {
        super.configureUI()
        //        view.backgroundColor = Constants.Color.subBGColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        mainView.setDefaultSelectDate(selectedDate)
        mainView.collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func modalTransition(vc: UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
    }
    
}

// MARK: Binding
extension CalendarViewController {
    
    private func bindData() {
        
        requestDayRecord
            .asDriver()
            .drive(with: self) { owner, date in
                owner.selectedDate = date
                owner.viewModel.filterDate(date)
            }
            .disposed(by: disposeBag)
        
        requestMonthData
            .asDriver(onErrorJustReturn: mainView.calendarView.currentPage)
            .drive(with: self) { owner, date in
                if let date = date {
                    owner.viewModel.getRecords(date: date)
                } else {
                    owner.viewModel.getRecords(date: owner.mainView.calendarView.currentPage)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.recordDates
            .bind(with: self) { owner, dates in
                owner.dateList = dates
                owner.mainView.calendarView.reloadData()
            }
            .disposed(by: disposeBag)
        
        
        viewModel.recordItem
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.collectionView.rx.items(dataSource: mainView.rxdataSource))
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(Record.self)
            .bind(with: self) { owner, item in
                if let place = item.placeInfo.first {
                    let vc = RecordReadViewController(record: item, location: place.toDomain())
                    owner.modalTransition(vc: vc)
                    
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindNotification() {
        NotificationCenterManager.updateCell.addObserver()
            .bind(with: self) { owner, _ in
                owner.requestMonthData.onNext(nil)
                owner.requestDayRecord.accept(owner.selectedDate)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Calendar Protocol
extension CalendarViewController: FSCalendarProtocol {
    
    func moveDate(date: Date) {
        requestDayRecord.accept(date)
    }
    
    func numberOfEventsFor(date: Date) -> Int {
        if self.dateList.contains(date){
            return 1
        }
        return 0
    }
    
    func calendarCurrentPageDidChange(date: Date) {
        requestMonthData.onNext(nil)
        requestDayRecord.accept(date)
    }
    
}
