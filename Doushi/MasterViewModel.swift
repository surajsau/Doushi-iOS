//
//  MasterViewModel.swift
//  Doushi
//
//  Created by Suraj Sau on 06/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class MasterViewModel {
    
    /*
        observers for viewmodels
     */
    let selectedSearchMode: AnyObserver<Int>
    
    let searchText: AnyObserver<String>
    
    let selectedItem: AnyObserver<ResultModel>
    
    /*
        observables for view
     */
    var result: Observable<[ResultModel]>
    
    var showDetails: Observable<String>
    
    init(with config: Realm.Configuration, localData: LocalData) {
        let realm = try! Realm(configuration: config)
        
        let _searchText = PublishSubject<String>()
        self.searchText = _searchText.asObserver()
        
        let _selectedSearchModePosition = BehaviorSubject<Int>(value: 0)
        self.selectedSearchMode = _selectedSearchModePosition.asObserver()
        
        let _selectedItem = PublishSubject<ResultModel>()
        self.selectedItem = _selectedItem.asObserver()
        self.showDetails = _selectedItem.asObservable().map{ item in
            localData.upsert(history: VerbHistory(verbReading: item.subTitle,
                        timeStamp: NSDate().timeIntervalSince1970,
                        times: 1))
            return item.subTitle
        }
        
        self.result = Observable.combineLatest( _selectedSearchModePosition, _searchText) { (position, text) in
            let mode = localData.searchModes[position]
            return realm.objects(Verb.self).filter(mode.getQuery(with: text)).map { ResultModel(verb: $0) }
        }
        
    }
    
}

enum SearchMode {
    case Combined
    case FirstVerb
    case SecondVerb
}

extension SearchMode {
    
    func getTitle() -> String {
        switch self {
        case .Combined:
            return "Combined"
        case .FirstVerb:
            return "First Verb"
        case .SecondVerb:
            return "Second Verb"
        }
    }
    
    func getQuery(with query: String) -> NSPredicate {
        switch self {
        case .FirstVerb:
            return NSPredicate(format: "firstVerbReading CONTAINS %@", query)
        case .SecondVerb:
            return NSPredicate(format: "secondVerbReading CONTAINS %@", query)
        case .Combined:
            return NSPredicate(format: "reading CONTAINS %@ OR firstVerbReading CONTAINS %@ OR secondVerbReading CONTAINS %@", query, query, query)
        }
    }
}
