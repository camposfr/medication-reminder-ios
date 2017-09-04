//
//  todayCell.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-01.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit

/// Class for the cells that contain Medication Info
class todayCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var pillNotice: UIImageView!
}
