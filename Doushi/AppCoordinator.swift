//
//  AppCoordinator.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    private let realmConfig: Realm.Configuration
    
    private let localData: LocalData
    
    init(window: UIWindow,
         realmConfig: Realm.Configuration,
         localData: LocalData) {
        self.window = window
        self.realmConfig = realmConfig
        self.localData = localData
    }
    
    override func start() -> Observable<Void> {
        let masterCoordinator = TabBarCoordinator(realmConfig: self.realmConfig, window: self.window, localData: self.localData)
        return coordinate(to: masterCoordinator)
    }
    
}
