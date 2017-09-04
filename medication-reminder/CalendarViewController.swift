//
//  CalendarViewController.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-01.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire
import SwiftyJSON

/// Class for the view of a calendar
class CalendarViewController: UIViewController
{
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    let formatter = DateFormatter()
    var segDate:Date!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCalendarView()

    }
    
    /// Starts the calendar
    func setupCalendarView()
    {
        calendarView.visibleDates
            { (visibleDates) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
    }
    
    /// Updates the cells colour
    ///
    /// - Parameters:
    ///   - view: A certain cell
    ///   - cellState: The status of a cell
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? calCell else {return}
        if cellState.dateBelongsTo == .thisMonth
        {
            validCell.dateLabel.textColor = UIColor.darkText
        }
        else
        {
            validCell.dateLabel.textColor = UIColor.gray
        }
    }
    
    /// Function to setup the view of a calendar
    ///
    /// - Parameter visibleDates: Dates to show
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        guard let startDate = visibleDates.monthDates.first?.date else
        {
            return
        }
        let monthC = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(monthC-1) % 12]
        let year = Calendar.current.component(.year, from: startDate)
        month.text = monthName + "-" + String(year)
        
    }
    
    /// Updates colour of selected date
    ///
    /// - Parameters:
    ///   - view: A Cell
    ///   - cellState: Status of cell
    func handleCellSelection(view: JTAppleCell?, cellState: CellState)
    {
        guard let validCell = view as? calCell else {return}
        if cellState.isSelected
        {
            validCell.backgroundColor = UIColor.red
        }
        else
        {
            validCell.backgroundColor = UIColor.white
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource
{
    /// Configures calendar with Date formats
    ///
    /// - Parameter calendar: Current calendar view
    /// - Returns: The config parameters
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: Date().toString(dateFormat: "YYYY MM dd"))!
        let endDate = formatter.date(from: (Calendar.current as NSCalendar).date(byAdding: .year, value: 1, to: Date(), options: [])!.toString(dateFormat: "YYYY MM dd"))!
        let param = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return param
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate
{
    /// Calendar generation
    ///
    /// - Parameters:
    ///   - calendar: Current calendar
    ///   - date: Date
    ///   - cellState: Status of Cell
    ///   - indexPath: Indexes
    /// - Returns: Returns a formatted cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell
    {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalCell", for: indexPath) as! calCell
        cell.dateLabel.text = cellState.text
        cell.selectedView.isHidden = true
        let dateString = date.toString(dateFormat: "YYYY MM dd")
        let todaySimple = Date().toString(dateFormat: "YYYY MM dd")
        
        if (todaySimple == dateString)
        {
            cell.selectedView.isHidden = false
        }
        
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    /// Function to prepare for segue sends a value to next view
    ///
    /// - Parameters:
    ///   - calendar: Current calendar
    ///   - date: Date selected
    ///   - cell: Selected ell
    ///   - cellState: Status of cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        self.segDate = date
        print("selected date: ",date)
        performSegue(withIdentifier: "nexts", sender: cell)

    }
    

    /// Sets up calendar with visible dates
    ///
    /// - Parameters:
    ///   - calendar: Current calendar
    ///   - visibleDates: Possible dates to show
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    
    /// Prepares for segue and send selected date
    ///
    /// - Parameters:
    ///   - segue: segue dto send the data through
    ///   - sender: Current sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "nexts"
        {
            if let toViewController = segue.destination as? CalendarTableController
            {
                toViewController.receiveDate = self.segDate
            }
        }
    }
}
