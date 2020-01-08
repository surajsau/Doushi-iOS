//
//  HistoryCoordinator.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class HistoryCoordinator: BaseCoordinator<Void> {
    
    private let localData: LocalData
    
    init(localData: LocalData) {
        self.localData = localData
    }
    
    override func start() -> Observable<Void> {
        let vc = HistoryViewController.initFromStoryboard(name: "Main")
        return Observable.never()
    }
    
}
