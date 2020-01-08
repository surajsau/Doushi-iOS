//
//  ResultCell.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(with verb: ResultModel?) {
        resultTitle.text = verb?.title
        resultSubTitle.text = verb?.subTitle
    }

}
