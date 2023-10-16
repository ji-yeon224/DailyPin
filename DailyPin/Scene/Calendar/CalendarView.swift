//
//  CalendarView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import Foundation
import UIKit
import FSCalendar

final class CalendarView: BaseView {
    
    lazy var currentPage = calendarView.currentPage
    weak var calendarDelegate: FSCalendarProtocol?
    weak var collectionViewDelegate: RecordCollectionViewProtocol?
    var dataSource: UICollectionViewDiffableDataSource<Int, Record>!
    
    lazy var calendarView = {
        let view = CustomCalendarView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.backgroundColor = Constants.Color.background
        view.delegate = self
        return view
    }()
    
    
    // 이전 달로 이동 버튼
    private let prevButton = {
        let view = UIButton()
        view.setImage(Constants.Image.leftButton, for: .normal)
        view.tintColor = Constants.Color.basicText
        return view
    }()
    
    // 다음 달로 이동 버튼
    private let nextButton = {
        let view = UIButton()
        view.setImage(Constants.Image.rightButton, for: .normal)
        view.tintColor = Constants.Color.basicText
        return view
    }()
    
    private let returnTodayButton = {
        let view = UIButton()
        view.setImage(Constants.Image.returnToday, for: .normal)
        view.tintColor = Constants.Color.basicText
        return view
    }()
    
    override func configureUI() {
        super.configureUI()
        addSubview(calendarView)
        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(returnTodayButton)
        addSubview(collectionView)
        configureDataSource()
        setAction()
    }
    
    
    
    override func setConstraints() {
        calendarView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(safeAreaLayoutGuide).multipliedBy(0.5)
            
        }
        
        prevButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.leading.equalTo(calendarView.calendarHeaderView.snp.leading).inset(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.trailing.equalTo(calendarView.calendarHeaderView.snp.trailing).inset(100)
        }
        
        returnTodayButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendarView.calendarHeaderView).multipliedBy(1.1)
            make.trailing.equalTo(calendarView.calendarHeaderView.snp.trailing).inset(15)
            
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        
    }
    
    private func setAction() {
        [prevButton, nextButton].forEach {
            $0.addTarget(self, action: #selector(moveMonthButtonDidTap(sender:)), for: .touchUpInside)
        }
        
        returnTodayButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        
    }
        
    @objc private func returnButtonTapped() {
        calendarView.setCurrentPage(Date(), animated: true)
        setDefaultSelectDate(Date())
        calendarDelegate?.returnButtonTapped()
    }
    
    @objc private func moveMonthButtonDidTap(sender: UIButton) {
        moveMonth(next: sender == nextButton)
    }
    
    // 달 이동 로직
    private func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        calendarView.setCurrentPage(self.currentPage, animated: true)
        setDefaultSelectDate(currentPage)
        calendarDelegate?.moveCalendar(date: currentPage)
        
    }
    
    func setDefaultSelectDate(_ date: Date){
        calendarView.select(date)
    }
    
}

// collection view
extension CalendarView: UICollectionViewDelegate  {
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        
        let screenWidth = UIScreen.main.bounds.width
        let estimatedHeight = NSCollectionLayoutDimension.estimated(screenWidth)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.interSectionSpacing = 5
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Record> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            cell.address.text = itemIdentifier.placeInfo[0].address
            cell.dateLabel.text = DateFormatter.convertDate(date: itemIdentifier.date)
            
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionViewDelegate?.didSelectRecordItem(item: nil)
            return
        }
        
        collectionViewDelegate?.didSelectRecordItem(item: item)
        
    }
    
}



extension CalendarView: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendarDelegate?.didSelectDate(date: date)
    }
   
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentMonth = DateFormatter.convertMonth(date: calendar.currentPage)
        calendarDelegate?.calendarCurrentPageDidChange(date: currentMonth)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        
        self.layoutIfNeeded()
    }
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun" || Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat" || Calendar.current.shortWeekdaySymbols[day] == "토" {
            return .systemBlue
        } else {
            return .label
        }
    }
    
    // 표시되는 이벤트 갯수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let data = calendarDelegate?.numberOfEventsFor(date: date) ?? 0
        return data
    }
    
    
}
