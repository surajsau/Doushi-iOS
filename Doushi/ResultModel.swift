//
//  ResultModel.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation

class ResultModel {
    
    let title: String
    let subTitle: String
    
    init(verb: Verb) {
        self.title = verb.firstForm ?? ""
        self.subTitle = verb.reading ?? ""
    }
    
}
