//
//  MeaningCell.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit

class MeaningCell: UITableViewCell {

    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(with model: MeaningListModel) {
        self.meaningLabel.text = model.meaning
        self.exampleLabel.text = model.example
    
        var usageText = ""
        for usage in model.usage {
            usageText.append(usage)
            usageText.append(" ")
        }
        
        self.usageLabel.text = usageText
    }

}
