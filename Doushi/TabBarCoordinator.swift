//
//  TabBarCoordinator.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class TabBarCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private let realmConfig: Realm.Configuration
    private let localData: LocalData
    
    init(realmConfig: Realm.Configuration, window: UIWindow, localData: LocalData) {
        self.window = window
        self.realmConfig = realmConfig
        self.localData = localData
    }
    
    override func start() -> Observable<Void> {
        let navigationViewController = UINavigationController()
        
        let masterNavController = UINavigationController()
        masterNavController.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        
        let historyNavController = UINavigationController()
        historyNavController.tabBarItem = UITabBarItem(title: "History", image: nil, selectedImage: nil)
        
        let tabViewController = UITabBarController()
        tabViewController.viewControllers = [masterNavController, historyNavController]
        
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
        
        let masterCoordinator = MasterCoordinator(realmConfig: realmConfig, localData: localData, window: window)
        coordinate(to: masterCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        let historyCoordinator = HistoryCoordinator(localData: localData)
        coordinate(to: historyCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
}
