//
//  MasterViewController.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class MasterViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet var searchBarScope: UISegmentedControl!
    @IBOutlet var searchTextField: SearchTextField!
    @IBOutlet var tableView: UITableView!
    
    static var storyboardIdentifier: String = "MasterVC"
    
    var viewModel: MasterViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.result
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "ResultCell", cellType: ResultCell.self)) { [weak self] (_, item, cell) in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
        
        searchBarScope.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.selectedSearchMode.mapObserver{ self.searchBarScope.selectedSegmentIndex })
            .disposed(by: disposeBag)
        
        searchTextField.rx.controlEvent(.editingChanged)
            .bind(to: viewModel.searchText.mapObserver{ self.searchTextField.text! })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ResultModel.self)
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected.bind(to: viewModel.selectedItem.mapObserver{ $0.row })
//            .disposed(by: disposeBag)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let verb = verbs?[viewModel.selectedPosition]
//        if let destinationVC = segue.destination as? DetailViewController {
//            destinationVC.verbReading = verb?.reading
//            destinationVC.searchDelegate = self
//        }
        
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

extension MasterViewController: SearchDelegate {
    
    func onVerbSelected(_ verb: String, _ isFirstVerb: Bool) {
        
    }
    
}

//extension MasterViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return verbs?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultCell
//
//        guard let verb = verbs?[indexPath.row] else {
//            return cell
//        }
//
//        cell.bind(with: ResultModel(verb: verb))
//        return cell
//    }
//
//}
