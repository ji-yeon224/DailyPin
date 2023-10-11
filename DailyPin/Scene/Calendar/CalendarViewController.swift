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
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        mainView.calendarDelegate = self
        
        
    }
    
    private func bindData() {
        viewModel.recordSortedByMonth.bind { data in
            print(data)
        }
        
        viewModel.recordDateList.bind { data in
            print(data)
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
    
    
}

extension CalendarViewController: FSCalendarProtocol {
    
    func didSelectDate(date: Date) {
        print(date)
    }
    
//    func numberOfEventsFor() -> Int {
//        
//    }
    
    func calendarCurrentPageDidChange(date: String) {
        viewModel.getRecords(date: date)
        // 컬렉션 뷰 갱신 구현
    }
    
}
