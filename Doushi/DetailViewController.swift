//
//  DetailViewController.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
 
    @IBOutlet weak var verbTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var firstVerb: UILabel!
    @IBOutlet weak var firstVerbReading: UILabel!
    
    @IBOutlet weak var secondVerb: UILabel!
    @IBOutlet weak var secondVerbReading: UILabel!
    
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var meaningsList: UITableView!
    
    @IBOutlet weak var firstVerbCard: UIView!
    @IBOutlet weak var secondVerbCard: UIView!
    
    private var realm: Realm!
    
    /*
        Parameter passed on HistoryViewController or FavoriteViewController
     */
    var verbReading: String!
    
    /*
        Result callback for SearchViewController
     */
    var searchDelegate: SearchDelegate?
    
    private var meanings: [MeaningListModel] = []
    
    private let localData = LocalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        realm = try! Realm(configuration: appDelegate.realmConfig)
        
        firstVerbCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstVerbClicked)))
        secondVerbCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondVerbClicked)))
        
    }
    
    @objc func firstVerbClicked() {
        searchDelegate?.onVerbSelected(firstVerb.text!, true)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func secondVerbClicked() {
        searchDelegate?.onVerbSelected(secondVerb.text!, true)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let predicate = NSPredicate(format: "reading == %@", verbReading)
        let verb = realm.objects(Verb.self).filter(predicate)[0] as Verb
        
        verbTitle.text = verb.firstForm
        subTitle.text = verb.reading
        
        firstVerb.text = verb.firstVerb
        firstVerbReading.text = verb.firstVerbReading
        
        secondVerb.text = verb.secondVerb
        secondVerbReading.text = verb.secondVerbReading
        
        firstVerbCard.layer.shadowColor = UIColor.black.cgColor
        firstVerbCard.layer.shadowOpacity = 0.15
        firstVerbCard.layer.shadowOffset = .zero
        firstVerbCard.layer.shadowRadius = 4
        
        secondVerbCard.layer.shadowColor = UIColor.black.cgColor
        secondVerbCard.layer.shadowOpacity = 0.15
        secondVerbCard.layer.shadowOffset = .zero
        secondVerbCard.layer.shadowRadius = 4
        
        let usagePattern = verb.usagePattern?.replacingOccurrences(of: "(1)", with: "")
                        .replacingOccurrences(of: "(2)", with: "")
                        .split(separator: ";")
        
        for (index, meaning) in verb.meanings.enumerated() {
            var pattern = ""
            if(index < usagePattern?.count ?? 0) {
                pattern = String(usagePattern?[index] ?? "").usageToHiragana()
            }
            meanings.append(meaning.toListModel(usagePattern: pattern))
        }

    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meanings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeaningCell", for: indexPath) as! MeaningCell
        let meaning = self.meanings[indexPath.row]
        
        cell.bind(with: meaning)
        
        return cell
    }
    
    
}

struct MeaningListModel {
    let meaning: String?
    let example: String?
    let usage: [String]
}
