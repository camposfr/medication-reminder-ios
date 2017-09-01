//
//  ViewController.swift
//  AlamofireWithSwiftyJSON
//
//  Created by MAC-186 on 4/12/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    let url: String = "http://localhost:9000/api/medications"
    let params: Parameters =
    [
            "start": Date().toString(dateFormat: "MM/dd/YYYY"),
            "end": (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: Date(), options: [])!.toString(dateFormat: "MM/dd/YYYY")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()


        Alamofire.request(URL(string: url)!, parameters: params).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")!
        var dict = arrRes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = dict["name"] as? String
        cell.detailTextLabel?.text = dict["dosage"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

