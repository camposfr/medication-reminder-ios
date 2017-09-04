//
//  Medications.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-08-31.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UserNotifications



/// Definition of Class Medications for the user
class Medications
{
    //Class atributes
    var id: String?
    var finalized: Bool?
    var missed: Bool?
    var dosage: String?
    var name: String?
    var time: Date?
    var active: Bool?
    var currentDate = Date()
    
    /// Medications Class initialization
    ///
    /// - Parameters:
    ///   - id: Unique Id
    ///   - finalized: Is this entry finalized
    ///   - missed: Is this entry missed
    ///   - dosage: Dosage for medication
    ///   - name: Medication Name
    ///   - time: Time to take Medication
    ///   - active: Was active
    init (id: String?, finalized: Bool?, missed: Bool?, dosage: String?, name: String?, time: Date?, active: Bool?)
    {
        self.id = id
        self.finalized = finalized
        self.missed = missed
        self.dosage = dosage
        self.name = name
        self.time = time
        self.active = active
        self.missed = Medications.missedCalc(calcDate: self.time!)
    }

    
    //Class Functions
    
    /// Calculates if Medication was missed
    ///
    /// - Parameter calcDate: Date of medication to calculate
    /// - Returns: Returns if Medication was missed
    class func missedCalc(calcDate:Date)->Bool
    {
        //Check if missed
        let localTime = calcDate
        let minute:TimeInterval = 60
        let timeOut = 5 * minute
        let missedCalc: Bool?
        if (Date() >  (localTime).addingTimeInterval(timeOut))
        {
            missedCalc = true
        }
        else
        {
            missedCalc = false
        }
        
        return missedCalc!
    }

    /// Converts a given String to Date with a format
    ///
    /// - Parameter calcDate: The date to convert
    /// - Returns: Returns the Date with format
    class func toDate(calcDate:String)->Date
    {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let time = dateFormatter.date(from: calcDate)
        return time!
    }
    

    /// Patches medication via Id in REST Server
    ///
    /// - Parameter Id: Unique Id of Medication
    class func patchIdMeds(Id: String)
    {
        let url: String = "http://localhost:9000/api/medications/" + Id
        let temp = Date()
        
        let d: Parameters =
        [
            "m":temp.toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"),
            "f":temp.toString(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z")
        ]
        
        let params: Parameters =
        [
            "d": d,
            "completed": true
        ]
        
        Alamofire.request(URL(string: url)!, method: .patch, parameters: params,encoding: JSONEncoding.default).responseJSON
        {
            (response) -> Void in
            //Print to console for debug
            if response.result.isSuccess {
                let resJson = JSON(response.result.value!)
                print(resJson)
            }
            if response.result.isFailure {
                let error : NSError = response.result.error! as NSError
                print(error)
            }
        }
    }
        
    
}
