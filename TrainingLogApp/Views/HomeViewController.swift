//
//  ViewController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

class HomeViewController: UIViewController {

    // MARK: - Properties & UIParts
    
    var calender: FSCalendar?
    private let disposeBag = DisposeBag()
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpCalender()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calender?.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: 300)
    }
    
    // MARK: - Setup & Bindings
        
    private func setUpCalender() {
        calender = FSCalendar()
        calender?.scrollDirection = .horizontal
        calender?.scope = .month
        
        calender?.appearance.titleFont = UIFont.systemFont(ofSize: 14)
        calender?.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        calender?.appearance.headerDateFormat = "yyyy年MM月"
        calender?.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16)
        
        calender?.appearance.todayColor = .systemMint
        calender?.appearance.titleTodayColor = .white
        calender?.appearance.headerTitleColor = .black
        calender?.appearance.weekdayTextColor = .blue
        calender?.appearance.titleWeekendColor = .red
        calender?.appearance.titleDefaultColor = .black
        calender?.delegate = self
        calender?.dataSource = self
        
        view.addSubview(calender!)
    }
  
}

// MARK: - FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("Date Selected == \(formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("Date De-Selected == \(formatter.string(from: date))")
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}

