//
//  MissedTableController.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-01.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

/// Class for Missed Meds
class MissedViewController: UIViewController
{
    
    @IBOutlet var tblJSON: UITableView!
    var meds = [Medications]()
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    let url: String = "http://localhost:9000/api/medications"
    let params: Parameters =
    [
        "start": Date().toString(dateFormat: "MM/dd/YYYY"),
        "end": (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: Date(), options: [])!.toString(dateFormat: "MM/dd/YYYY")
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getData()

    }

    /// Gets data using REST from server
    func getData()
    {
        //Get data to populate cells
        Alamofire.request(URL(string: url)!, parameters: params).responseJSON
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
                    if(self.arrRes[x]["completed"] as? Bool == false)
                    {
                        var das: Date!
                        if let timeString = swiftyJsonVar[x]["time"].string
                        {
                            das = timeString.toDate!
                        }
                            
                        //Check if medication was missed
                        if (Medications.missedCalc(calcDate: das!))
                        {
                            self.meds.append(Medications(id: self.arrRes[x]["_id"] as? String, finalized: self.arrRes[x]["completed"] as? Bool, missed: true, dosage: self.arrRes[x]["dosage"] as? String, name: self.arrRes[x]["name"] as? String, time: das, active: true))
                        }
                    }
                }
                self.meds.sort
                {
                    $0.id! < $1.id!
                }
                    
                if self.arrRes.count > 0
                {
                    self.tblJSON.reloadData()
                }
            }
        }
    }
    
    /// Function to add Formatted cells
    ///
    /// - Parameters:
    ///   - tableView: Current Tableview
    ///   - indexPath: Indexes
    /// - Returns: A fully formatted cell
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell : todayCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")! as! todayCell
        cell.titleLabel.text = meds[(indexPath as NSIndexPath).row].name
        cell.subtitleLabel.text = meds[(indexPath as NSIndexPath).row].dosage
        cell.hourLabel.text = meds[(indexPath as NSIndexPath).row].time?.toString(dateFormat: "MM/dd/YYYY  h:mm a")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return meds.count
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

