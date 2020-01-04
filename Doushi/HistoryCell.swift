//
//  HistoryCell.swift
//  Doushi
//
//  Created by Suraj Sau on 04/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var verbReadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(with object: VerbHistory) {
        verbReadingLabel.text = object.verbReading
    }

}
