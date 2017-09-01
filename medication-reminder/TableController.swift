//
//  TableController.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-08-31.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import Alamofire

class TableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Declare variables
    let cellList = ["A", "B", "C"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = cellList[indexPath.row]
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Get Today's Medications Test
        Medications.getDayMeds(start: Date(), end: (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to: Date(), options: [])!, status: 1)
        //Patch Medications Test
        Medications.patchIdMeds(Id: "59a8481b53e5a9d81efa85ab")


        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
