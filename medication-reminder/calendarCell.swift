//
//  calendarCell.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-01.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import JTAppleCalendar

/// Class for Date numbers to be displayed and able to be selected
class calCell: JTAppleCell
{
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var  selectedView: UIView!
}
