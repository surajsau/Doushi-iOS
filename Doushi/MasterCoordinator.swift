//
//  MasterCoordinator.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class MasterCoordinator: BaseCoordinator<Void> {
    
    private let realmConfig: Realm.Configuration
    
    private let localData: LocalData
    
    private let window: UIWindow
    
    init(realmConfig: Realm.Configuration, localData: LocalData, window: UIWindow) {
        self.realmConfig = realmConfig
        self.localData = localData
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = MasterViewModel(with: realmConfig, localData: localData)
        let viewController = MasterViewController.initFromStoryboard()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        viewModel.showDetails
            .flatMap { [weak self] verbReading -> Observable<String> in
                guard let `self` = self else { return .empty() }
                return self.showDetails(with: verbReading, navController: navigationController)
            }
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showDetails(with verbReading: String, navController: UINavigationController) -> Observable<String> {
        let detailCoordinator = DetailCoordinator(realmConfig: realmConfig, verbReading: verbReading, window: window)
        detailCoordinator.rootNavController = navController
        
        return coordinate(to: detailCoordinator)
    }
    
}
