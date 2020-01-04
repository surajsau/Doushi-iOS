//
//  MasterViewController.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit
import RealmSwift


class MasterViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: SearchTextField!
    
    private var realm: Realm!
    
    private var currentSelectedItem = 0
    
    private var filteredVerbs: Results<Verb>?
    
    private var currentMode = SearchMode.Combined
    
    private let modes = [SearchMode.Combined, SearchMode.FirstVerb, SearchMode.SecondVerb]
    
    private let localData = LocalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        realm = try! Realm(configuration: appDelegate.realmConfig)
        
        tableView.keyboardDismissMode = .onDrag
        
        searchTextField.addTarget(self, action: #selector(filterSearch), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let verb = filteredVerbs?[self.currentSelectedItem]
        if let destinationVC = segue.destination as? DetailViewController {
            destinationVC.verbReading = verb?.reading
            destinationVC.searchDelegate = self
        }
        
    }
    
    /*
        core function which performs the search from the existing Realm Database
     */
    @objc func filterSearch() {
        let searchText = searchTextField.text!
        let predicate = NSPredicate(format: currentMode.getQuery(), searchText)
        filteredVerbs = realm.objects(Verb.self).filter(predicate)
        
        tableView.reloadData()
    }
    
}

/*
    Delegate used to obsever result from the Details screen
 */
protocol SearchDelegate {
    
    /*
        result callback from Details screen on selecting either of the verbs.
     
        verb: String of the verb dict form
        isFirstVerb: Whether the verb is the first verb or second
     */
    func onVerbSelected(_ verb: String, _ isFirstVerb: Bool)
    
}

extension MasterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVerbs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultCell
        
        let verb = filteredVerbs?[indexPath.row]
        cell.bind(with: verb)
        return cell
    }

}

extension MasterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let verb = filteredVerbs?[indexPath.row]
        self.localData.upsert(history: VerbHistory(verbReading: verb?.reading ?? "",
                                                   timeStamp: NSDate().timeIntervalSince1970,
                                                   times: 1))
        
        self.currentSelectedItem = indexPath.row
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
}

extension MasterViewController: SearchDelegate {
    
    func onVerbSelected(_ verb: String, _ isFirstVerb: Bool) {
        
        if(isFirstVerb) {
            self.currentMode = SearchMode.FirstVerb
        } else {
            self.currentMode = SearchMode.SecondVerb
        }
        
        filterSearch()
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
    
    func getQuery() -> String {
        switch self {
        case .FirstVerb:
            return "firstVerbReading CONTAINS %@"
        case .SecondVerb:
            return "secondVerbReading CONTAINS %@"
        case .Combined:
            return "reading CONTAINS %@"
        }
    }
}

