//
//  CalendarViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 2. 16..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: ViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var completionBarButton: UIBarButtonItem!
    let formatter = DateFormatter()
    var prePostVisibility: ((CellState, CalendarCell?)->())?
    var todayComponents: DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar.dateComponents([.year, .month, .day], from: Date())
    }
    var delegate: KeepDayViewController?
    var selectedDate: Date?
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red:  101/255, green: 121/255, blue: 151/255, alpha: 1).cgColor,
                                UIColor(red: 87/255, green: 70/255, blue: 115/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        setViewController()
        print(Date().description(with: Locale.current))
    }
    
    override func setViewController() {
        self.completionBarButton.isEnabled = false
    }
    
    func setUpCalendarView() {
        self.calendarView.showsHorizontalScrollIndicator = false
        self.calendarView.showsVerticalScrollIndicator = false
        self.calendarView.isPagingEnabled = true
        self.calendarView.scrollDirection = UICollectionViewScrollDirection.vertical
        self.calendarView.ibCalendarDelegate = self
        self.calendarView.ibCalendarDataSource = self
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.prePostVisibility = {state, cell in
            if state.dateBelongsTo == .thisMonth {
                cell?.isHidden = false
            } else {
                cell?.isHidden = true
            }
        }
        
        self.calendarView.visibleDates { (visibleDates) in
            self.getCalendarVisibleDates(from: visibleDates)
        }
        self.calendarView.reloadData()
        self.calendarView.scrollToDate(Date())
    }
    
    func getCalendarVisibleDates(from visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            self.formatter.dateFormat = "yyyy년"
            self.yearLabel.text = self.formatter.string(from: date)
            
            self.formatter.dateFormat = "M월"
            self.monthLabel.text = self.formatter.string(from: date)
        }
    }
    
    @IBAction func dismissCalendar(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completionSelectDate(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.delegate?.selectedDate = self.selectedDate
        }
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        guard let cell = cell as? CalendarCell else {return }
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone =  Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let today = formatter.date(from: "\(todayComponents.year!) \(todayComponents.month!) \(todayComponents.day!)")!
        cell.todayDisplayView.isHidden = !(cellState.date == today)
        self.prePostVisibility?(cellState, cell as? CalendarCell)
    }
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState){
        guard let cell = cell as? CalendarCell else {
            return
        }
        switch cellState.isSelected {
        case true:
            cell.selectedView.isHidden = false
        case false:
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        guard let cell = cell as? CalendarCell else {return }
        switch cellState.dateBelongsTo {
        case .thisMonth:
            cell.isUserInteractionEnabled = false
            formatter.dateFormat = "yyyy MM dd"
            formatter.timeZone =  Calendar.current.timeZone
            formatter.locale = Calendar.current.locale
            let today = formatter.date(from: "\(todayComponents.year!) \(todayComponents.month!) \(todayComponents.day!)")!
            if cellState.date <= today {
                cell.dateLabel.textColor = UIColor.lightGray
            }
            else {
                switch cellState.isSelected {
                case true:
                    cell.dateLabel.textColor = UIColor.white
                case false:
                    cell.dateLabel.textColor = UIColor.black
                }
                
                cell.isUserInteractionEnabled = true
            }
        default :
            break
        }
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone =  TimeZone.current
        formatter.locale = Locale.current
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        let start = formatter.date(from: "\(todayComponents.year!) 01 01")
        let end = formatter.date(from: "\(todayComponents.year! + 5) 12 31")
        return ConfigurationParameters(startDate: start!, endDate: end!, generateOutDates: .tillEndOfRow)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
        print(date.description(with: Locale.current))
        self.completionBarButton.isEnabled = true
        self.selectedDate = date
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.getCalendarVisibleDates(from: visibleDates)
    }
}
