//
//  HistoryViewController.swift
//  Doushi
//
//  Created by Suraj Sau on 04/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, StoryboardInitializable {

    static var storyboardIdentifier: String = "HistoryVC"
    
    private let localData = LocalData()
    
    private var data: [VerbHistory] = []
    
    private var currentSelectedItem: Int = 0
    
    @IBOutlet var historyTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        data = localData.fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let history = data[currentSelectedItem]
        if let destinationVC = segue.destination as? DetailViewController {
            destinationVC.verbReading = history.verbReading
        }
    }

}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! HistoryCell
        cell.bind(with: data[indexPath.row])
        
        return cell
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentSelectedItem = indexPath.row
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
}
