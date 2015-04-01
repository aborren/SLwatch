//
//  StationTableViewCell.swift
//  SLwatch
//
//  Created by Dan Isacson on 16/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet var starButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func favouriteBtnPressed(sender: AnyObject) {
        println("pressed")
    }
}
