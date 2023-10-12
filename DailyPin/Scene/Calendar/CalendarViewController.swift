//
//  CalendarViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import UIKit

final class CalendarViewController: BaseViewController {
    
    private let mainView = CalendarView()
    private let viewModel = CalendarViewModel()
    private var dateList: [Date] = []
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        mainView.calendarDelegate = self
        //mainView.collectionViewDelegate = self
        viewModel.filterDate(DateFormatter.convertCalendarDate(date: Date()))
        updateSnapShot()
        mainView.setDefaultSelectDate(Date())
    }
    
    private func bindData() {
        
        viewModel.recordDateList.bind { data in
            self.dateList = data
        }
        
        viewModel.recordFileterByDate.bind { data in
            self.updateSnapShot()
            
        }
    }
    
    override func configureUI() {
        super.configureUI()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        let date = DateFormatter.convertMonth(date: mainView.currentPage)
        viewModel.getRecords(date: date)
        
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Record>()
        snapShot.appendSections([0])
        snapShot.appendItems(viewModel.recordFileterByDate.value)
        mainView.dataSource.apply(snapShot)
    }
    
    
}

extension CalendarViewController: FSCalendarProtocol {
    
    func moveCalendar(date: Date) {
        viewModel.filterDate(DateFormatter.convertCalendarDate(date: date))
    }
    
    func didSelectDate(date: Date) {
        viewModel.filterDate(DateFormatter.convertCalendarDate(date: date))
        
    }
    
    func numberOfEventsFor(date: Date) -> Int {
        if self.dateList.contains(date){
            return 1
        }
        return 0
    }
    
    func calendarCurrentPageDidChange(date: String) {
        viewModel.getRecords(date: date)
        
    }
    
}

//extension CalendarViewController: RecordCollectionViewProtocol {
//    func didSelectRecordItem(item: Record?) {
//        guard let item = item else {
//            showOKAlert(title: "", message: "데이터를 로드하는데 문제가 발생하였습니다.") { }
//            return
//        }
//
//        let vc = RecordViewController()
//        vc.record = item
//        vc.location = viewModel.place.value
//        vc.editMode = false
//
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .overFullScreen
//        nav.modalTransitionStyle = .crossDissolve
//
//        present(nav, animated: true)
//
//    }
//}
