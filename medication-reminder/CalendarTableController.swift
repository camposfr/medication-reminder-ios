//
//  CalendarTableController.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-03.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications

/// Class for Calendar Controller
class CalendarTableController: UIViewController
{
    
    @IBOutlet var tblJSONCal: UITableView!
    var meds = [Medications]()
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var receiveDate: Date!
    let url: String = "http://localhost:9000/api/medications"

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Got: ",receiveDate)
        let params: Parameters =
        [
            "start": receiveDate.toString(dateFormat: "MM/dd/YYYY"),
            "end": (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: receiveDate, options: [])!.toString(dateFormat: "MM/dd/YYYY")
        ]
        //Asked for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        getData(parameters: params)
        
    }
    
    /// Gets data using REST from server
    ///
    /// - Parameter parameters: Start and End dates for query
    func getData(parameters: Parameters)
    {
        //Get data to populate cells
        Alamofire.request(URL(string: url)!, parameters: parameters).responseJSON
        {
            (responseData) -> Void in
            if ((responseData.result.value) != nil)
            {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
    
                if let resData = swiftyJsonVar.arrayObject
                {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
    
                for x in 0..<self.arrRes.count
                {
    
                    var das: Date!
                    if let timeString = swiftyJsonVar[x]["time"].string
                    {
                        das = timeString.toDate!
                    }
    
                    self.meds.append(Medications(id: self.arrRes[x]["_id"] as? String, finalized: self.arrRes[x]["completed"] as? Bool, missed: true, dosage: self.arrRes[x]["dosage"] as? String, name: self.arrRes[x]["name"] as? String, time: das, active: true))
                    
                }
                self.meds.sort
                {
                        $0.id! < $1.id!
                }
    
                if self.arrRes.count > 0
                {
                    self.tblJSONCal.reloadData()
                }
            }
        }
    }
    
    /// Function to add Cells to view
    ///
    /// - Parameters:
    ///   - tableView: Current table view
    ///   - indexPath: Indexes for cells
    /// - Returns: A fully formatted TableViewCell
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell : todayCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")! as! todayCell
        cell.titleLabel.text = meds[(indexPath as NSIndexPath).row].name
        cell.subtitleLabel.text = meds[(indexPath as NSIndexPath).row].dosage
        cell.hourLabel.text = meds[(indexPath as NSIndexPath).row].time?.toString(dateFormat: "MM/dd/YYYY  h:mm a")
        if((meds[(indexPath as NSIndexPath).row].finalized)! == true && Medications.missedCalc(calcDate: (meds[(indexPath as NSIndexPath).row].time)!))
        {
            let imageName = "ico_nwn.png"
            let image = UIImage(named: imageName)
            cell.pillNotice.image = image
        }
        else if((meds[(indexPath as NSIndexPath).row].finalized)! == false && Date() < meds[(indexPath as NSIndexPath).row].time!)
        {
            let imageName = "ico_owo.png"
            let image = UIImage(named: imageName)
            cell.pillNotice.image = image
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meds.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

