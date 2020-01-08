//
//  BaseViewController.swift
//  Doushi
//
//  Created by Suraj Sau on 08/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class BaseViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    func bindText(_ observable: Observable<String?>, to viewBinder: Binder<String?>) {
        observable.bind(to: viewBinder).disposed(by: disposeBag)
    }
    
    func bindText(_ observable: Observable<String>, to viewBinder: Binder<String?>) {
        observable.bind(to: viewBinder).disposed(by: disposeBag)
    }
    
}
