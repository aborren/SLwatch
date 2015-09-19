//
//  DepartureTableViewCell.swift
//  SLwatch
//
//  Created by Dan Isacson on 16/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

class DepartureTableViewCell: UITableViewCell {

    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpRow(departure: Departure){
        if let line = departure.lineNumber {
            if let direction = departure.direction{
                self.firstLabel.text = "\(line) \(direction)"
            }else{
                self.firstLabel.text = line
            }
        }else{
            if let direction = departure.direction{
                self.firstLabel.text = "\(direction)"
            }else{
                self.firstLabel.text = "Unknown destination"
            }
        }
        
        if let departureTime = departure.departureTime {
            let df = NSDateFormatter()
            df.dateFormat = "HH:mm"
            self.secondLabel.text = df.stringFromDate(departureTime)
        }
    }
}
