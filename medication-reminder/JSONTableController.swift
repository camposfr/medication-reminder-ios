//
//  JSONTableController.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-01.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import UserNotifications
import SwiftySound

/// Class for controlling medications
class ViewController: UIViewController
{

    @IBOutlet var tblJSON: UITableView!
    var meds = [Medications]()
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    var timer = Timer()
    let url: String = "http://localhost:9000/api/medications"
    let params: Parameters =
    [
        "start": Date().toString(dateFormat: "MM/dd/YYYY"),
        "end": (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: Date(), options: [])!.toString(dateFormat: "MM/dd/YYYY")
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblJSON.reloadData()
        //Asked for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        getData()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alarmTrigger), userInfo: nil, repeats: true)

    }
    
    /// Gets data using REST from server
    func getData()
    {
        //Delete all previous data
        arrRes.removeAll()

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
                        if (Medications.missedCalc(calcDate: das!)==false)
                        {
                            self.meds.append(Medications(id: self.arrRes[x]["_id"] as? String, finalized: self.arrRes[x]["completed"] as? Bool, missed: false, dosage: self.arrRes[x]["dosage"] as? String, name: self.arrRes[x]["name"] as? String, time: das, active: true))
                                
                            addNotification(title: "Time to take the Medications", subTitle: self.arrRes[x]["name"] as? String as Any as! String, body: self.arrRes[x]["dosage"] as? String as Any as! String, id:self.arrRes[x]["_id"] as? String as Any as! String, date: das)
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
    
    /// Function to trigger the alarms and update the actions
    func alarmTrigger() {
        for medT in self.meds {
            if let finalized = medT.finalized, let time = medT.time
            {
                if !finalized
                {
                    let currentTime = Date()
                    //Enable take pill button
                    if (Calendar.current as NSCalendar).date(byAdding: .second, value: 300, to: currentTime, options: [])! >= (Calendar.current as NSCalendar).date(byAdding: .second, value: 0, to: time, options: [])! && (Calendar.current as NSCalendar).date(byAdding: .second, value: 0, to: currentTime, options: [])! <= (Calendar.current as NSCalendar).date(byAdding: .second, value: 300, to: time, options: [])! && medT.finalized == false{
                        print("button activated")
                        medT.active = false
                        self.reloadInputViews()
                        tblJSON.reloadData()
                    }
                    
                    //Alarm
                    if (Calendar.current as NSCalendar).date(byAdding: .second, value: 0, to: currentTime, options: [])! >= (Calendar.current as NSCalendar).date(byAdding: .second, value: -1, to: time, options: [])! && (Calendar.current as NSCalendar).date(byAdding: .second, value: 0, to: currentTime, options: [])! <= (Calendar.current as NSCalendar).date(byAdding: .second, value: 2, to: time, options: [])!{
                        print("alarm activated")
                        Sound.play(file: "pills", fileExtension: "aiff", numberOfLoops: 0)
                        self.reloadInputViews()
                        if(createAlert (title:"Medication Reminder", message:"Take medication?") == true)
                        {
                            medT.active = true
                            medT.finalized = true
                            self.reloadInputViews()
                            tblJSON.reloadData()
                        }
                    }
                    //Late alarm
                    if (Calendar.current as NSCalendar).date(byAdding: .second, value: 0, to: currentTime, options: [])! >= (Calendar.current as NSCalendar).date(byAdding: .minute, value: 5, to: time, options: [])! && (Calendar.current as NSCalendar).date(byAdding: .second, value: 0, to: currentTime, options: [])! <= (Calendar.current as NSCalendar).date(byAdding: .second, value: 305, to: time, options: [])! {
                        print("late alarm activated")
                        print("button deactivated")
                        Sound.play(file: "pills_late", fileExtension: "aiff", numberOfLoops: 0)
                        medT.active = true
                        if(createAlert (title:"Last Chance!", message:"Take medication?") == true)
                        {
                            medT.active = true
                            medT.finalized = true
                            self.reloadInputViews()
                        }
                        medT.missed = true
                        self.reloadInputViews()
                        tblJSON.reloadData()
                    }
                }
            }
        }
    }

    /// Function to ad formatted cells
    ///
    /// - Parameters:
    ///   - tableView: Current Table view
    ///   - indexPath: Indexes
    /// - Returns: A Fully formatted cell
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell : todayCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")! as! todayCell
        cell.titleLabel.text = meds[(indexPath as NSIndexPath).row].name
        cell.subtitleLabel.text = meds[(indexPath as NSIndexPath).row].dosage
        cell.hourLabel.text = meds[(indexPath as NSIndexPath).row].time?.toString(dateFormat: "MM/dd/YYYY  h:mm a")
        cell.takeButton.tag = (indexPath as NSIndexPath).row
        cell.takeButton.addTarget(self, action:#selector(takeMed(sender:)), for: .touchUpInside)
        cell.takeButton.isHidden = (meds[(indexPath as NSIndexPath).row].active)!
        cell.pillNotice.isHidden = (meds[(indexPath as NSIndexPath).row].active)! == false
        if((meds[(indexPath as NSIndexPath).row].missed)!)
        {
            let imageName = "ico_uwu.png"
            let image = UIImage(named: imageName)
            cell.pillNotice.image = image
        }
        else if((meds[(indexPath as NSIndexPath).row].missed)! == false && (meds[(indexPath as NSIndexPath).row].finalized)! == true)
        {
            let imageName = "ico_nwn.png"
            let image = UIImage(named: imageName)
            cell.pillNotice.image = image
        }
        return cell
    }
    
    /// Declares a medication as taken and updates all data related
    ///
    /// - Parameter sender: A button
    func takeMed(sender:UIButton)
    {
        print(meds[sender.tag].id!)
        if(meds[sender.tag].missed! == false)
        {
            Medications.patchIdMeds(Id: meds[sender.tag].id!)
        }
        meds[sender.tag].finalized = true
        meds[sender.tag].active = true
        sender.isHidden = true
        // Remove that notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [meds[sender.tag].id!])
        tblJSON.reloadData()
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
    
    //Create Alert
    /// Creates an Alert before Medication is missed
    ///
    /// - Parameters:
    ///   - title: Medication reminder
    ///   - message: Message to send
    /// - Returns: The selection of the notification
    func createAlert (title:String, message:String)->Bool
    {
        var selection: Bool = false
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("YES")
            selection = true
            Medications.patchIdMeds(Id: self.meds[0].id!)
            // Remove that notification
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.meds[0].id!])
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("NO")
            selection = false
        }))
        
        self.present(alert, animated: true, completion: nil)
        return selection
    }

    
}

