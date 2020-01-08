//
//  AppDelegate.swift
//  Doushi
//
//  Created by Suraj Sau on 30/12/19.
//  Copyright © 2019 Suraj Sau. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!
    
    private var disposeBag = DisposeBag()
    
    lazy var localData: LocalData = {
        return LocalData()
    }()

    lazy var persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Doushi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error: \((error as NSError).userInfo)")
            }
        })
        
        return container
    }()
    
    lazy var realmConfig: Realm.Configuration = {
        let realmPath = Bundle.main.path(forResource: "verb", ofType: "realm")
        
        return Realm.Configuration(
            fileURL: URL(fileURLWithPath: realmPath!),
            readOnly: true,
            schemaVersion: 1)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: self.window!, realmConfig: self.realmConfig, localData: self.localData)
        self.appCoordinator.start()
            .subscribe()
            .disposed(by: self.disposeBag)
        return true
    }

}

