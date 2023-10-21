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
        navigationController?.navigationBar.isHidden = false
        bindData()
        mainView.calendarDelegate = self
        mainView.collectionViewDelegate = self
        viewModel.filterDate(selectedDate)
        updateSnapShot()
        mainView.setDefaultSelectDate(selectedDate)
        mainView.collectionView.collectionViewLayout.invalidateLayout()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func bindData() {
        
        viewModel.recordDateList.bind { data in
            self.dateList = data
            print("bind", data)
        }
        
        viewModel.recordFileterByDate.bind { data in
            self.updateSnapShot()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButton, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constants.Color.basicText
        
        let date = mainView.calendarView.currentPage
        viewModel.getRecords(date: date)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: Notification.Name.updateCell, object: nil)
        
    }
    
    @objc private func getChangeNotification(notification: NSNotification) {
        
        viewModel.getRecords(date: mainView.calendarView.currentPage)
        viewModel.filterDate(selectedDate)
        mainView.calendarView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
        viewModel.filterDate(Date())
        selectedDate = Date()
    }
    
    func moveCalendar(date: Date) {
        viewModel.filterDate(date)
        selectedDate = date
    }
    
    func didSelectDate(date: Date) {
        viewModel.filterDate(date)
        selectedDate = date
    }
    
    func numberOfEventsFor(date: Date) -> Int {
        if self.dateList.contains(date){
            return 1
        }
        return 0
    }
    
    func calendarCurrentPageDidChange(date: Date) {
        let currentMonth = DateFormatter.convertMonth(date: date)
        viewModel.getRecords(date: mainView.calendarView.currentPage)
        viewModel.filterDate(date)
        selectedDate = date
        mainView.calendarView.reloadData()
        
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
        vc.mode = .read
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
