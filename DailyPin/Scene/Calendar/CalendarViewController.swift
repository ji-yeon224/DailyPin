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
    private var selectedDate = Date()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        mainView.calendarDelegate = self
        mainView.collectionViewDelegate = self
        viewModel.filterDate(convertDate(selectedDate))
        updateSnapShot()
        mainView.setDefaultSelectDate(selectedDate)
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        let date = DateFormatter.convertMonth(date: mainView.currentPage)
        viewModel.getRecords(date: date)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: Notification.Name.updateCell, object: nil)
        
    }
    
    @objc private func getChangeNotification(notification: NSNotification) {
        let currentMonth = DateFormatter.convertMonth(date: mainView.calendarView.currentPage)
        viewModel.getRecords(date: currentMonth)
        viewModel.filterDate(convertDate(selectedDate))
        mainView.calendarView.reloadData()
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
    
    func convertDate(_ date: Date) -> String {
        return DateFormatter.convertCalendarDate(date: date)
    }
    
}



extension CalendarViewController: FSCalendarProtocol {
    
    func returnButtonTapped() {
        viewModel.filterDate(convertDate(Date()))
        selectedDate = Date()
    }
    
    func moveCalendar(date: Date) {
        viewModel.filterDate(convertDate(date))
        selectedDate = date
    }
    
    func didSelectDate(date: Date) {
        viewModel.filterDate(convertDate(date))
        selectedDate = date
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

extension CalendarViewController: RecordCollectionViewProtocol {
    func didSelectRecordItem(item: Record?) {
        guard let item = item else {
            showOKAlert(title: "", message: "alert_dateLoadError".localized()) { }
            return
        }
        
        guard let place = item.placeInfo.first else {
            showOKAlert(title: "", message: "alert_locationLoadError".localized()) { }
            return
        }
        
        let vc = RecordViewController()
        vc.record = item
        vc.location = convertToStruct(place)
        vc.editMode = false
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve

        present(nav, animated: true)

    }
    
    private func convertToStruct(_ item: Place) -> PlaceElement {
        
        let location = Location(latitude: item.latitude, longitude: item.longitude)
        let displayName = DisplayName(placeName: item.placeName)
        
        return PlaceElement(id: item.placeId, formattedAddress: item.address, location: location, displayName: displayName)
    }
}
