//
//  DetailViewModel.swift
//  Doushi
//
//  Created by Suraj Sau on 07/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class DetailViewModel {
    
    let verbItemClicked: AnyObserver<Int>
    
    let setResultToSearch: Observable<String>
    
    let title: Observable<String>
    
    let subTitle: Observable<String>
    
    let firstVerb: Observable<String?>
    
    let firstVerbReading: Observable<String?>
    
    let secondVerb: Observable<String?>
    
    let secondVerbReading: Observable<String?>
    
    let meanings: Observable<[MeaningListModel]>
    
    init(with realmConfig: Realm.Configuration, verbReading: String) {
        let realm = try! Realm(configuration: realmConfig)
        
        let predicate = NSPredicate(format: "reading == %@", verbReading)
        let verb = realm.objects(Verb.self).filter(predicate)[0] as Verb
        
        let _verbItemClicked = PublishSubject<Int>()
        self.verbItemClicked = _verbItemClicked.asObserver()
        
        self.setResultToSearch = _verbItemClicked.asObservable().map {
            switch $0 {
            case 1:
                return verb.firstVerbReading ?? ""
            case 2:
                return verb.secondVerbReading ?? ""
            default:
                return ""
            }
        }
        
        let _verb = Observable.just(verb)
        
        self.title = _verb.map { $0.firstForm ?? "" }
        self.subTitle = _verb.map { $0.reading ?? "" }
        
        self.firstVerb = _verb.map { $0.firstVerb }
        self.secondVerb = _verb.map { $0.secondVerb }
        self.firstVerbReading = _verb.map { $0.firstVerbReading }
        self.secondVerbReading = _verb.map { $0.secondVerbReading }
        
        
        self.meanings = _verb.map {
            var meanings: [MeaningListModel] = []
            let usagePattern = $0.usagePattern?.replacingOccurrences(of: "(1)", with: "")
                            .replacingOccurrences(of: "(2)", with: "")
                            .split(separator: ";")

            for (index, meaning) in verb.meanings.enumerated() {
                var pattern = ""
                if(index < usagePattern?.count ?? 0) {
                    pattern = String(usagePattern?[index] ?? "").usageToHiragana()
                }
                meanings.append(meaning.toListModel(usagePattern: pattern))
            }
            
            return meanings
        }

    }
    
}
