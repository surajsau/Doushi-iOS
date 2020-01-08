//
//  DetailCoordinator.swift
//  Doushi
//
//  Created by Suraj Sau on 08/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import UIKit

class DetailCoordinator: BaseCoordinator<String> {
    
    let realmConfig: Realm.Configuration
    let verbReading: String
    let window: UIWindow
    var searchDelegate: SearchDelegate?
    var rootNavController: UINavigationController?
    
    init(realmConfig: Realm.Configuration, verbReading: String, window: UIWindow) {
        self.realmConfig = realmConfig
        self.verbReading = verbReading
        self.window = window
    }
    
    override func start() -> Observable<String> {
        let viewController = DetailViewController.initFromStoryboard()
        let navigationController = UINavigationController(rootViewController: viewController)
        let viewModel = DetailViewModel(with: realmConfig, verbReading: verbReading)
        
        viewController.viewModel = viewModel
        viewController.searchDelegate = searchDelegate
        
        viewModel.setResultToSearch
            .subscribe(onNext: { [weak self] verb in
                self?.sendResult(with: verb, from: navigationController)
            })
            .disposed(by: disposeBag)
        
        rootNavController?.pushViewController(viewController, animated: true)
        
        window.rootViewController = rootNavController
        window.makeKeyAndVisible()
        
        return viewModel.setResultToSearch
    }
    
    private func sendResult(with verb: String, from navigationController: UINavigationController) {
        
        navigationController.popViewController(animated: true)
        
    }
    
}
