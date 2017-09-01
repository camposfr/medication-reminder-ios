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


//Class definition
class Medications
{
    //Class atributes
    var id: String?
    var finalized: Bool?
    var missed: Bool?
    var dosage: String?
    var name: String?
    var time: String?
    var active: Bool?
    var currentDate = Date()
    
    //Class initialization
    init (id: String?, finalized: Bool?, missed: Bool?, dosage: String?, name: String?, time: String?, active: Bool?)
    {
        self.id = id
        self.finalized = finalized
        self.missed = missed
        self.dosage = dosage
        self.name = name
        self.time = time
        self.active = active
    }
    
    //Class Functions
    //Getting medication data
    class func getDayMeds(start: Date, end: Date, status: Int)
    {
        let url: String = "http://localhost:9000/api/medications"
        let params: Parameters =
            [
                "start": start.toString(dateFormat: "MM/dd/YYYY"),
                "end": end.toString(dateFormat: "MM/dd/YYYY")
            ]
        
        Alamofire.request(URL(string: url)!, method: .get, parameters: params).validate().responseJSON
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
    

    //Patching medication Id
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
