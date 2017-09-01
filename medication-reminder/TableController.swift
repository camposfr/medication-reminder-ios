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
        Medications.getDayMeds(start: Date(), end: Date(), status: 1)


        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
