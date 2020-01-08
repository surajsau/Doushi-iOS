//
//  DetailViewController.swift
//  Doushi
//
//  Created by Suraj Sau on 02/01/20.
//  Copyright © 2020 Suraj Sau. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class DetailViewController: BaseViewController, StoryboardInitializable {
 
    static var storyboardIdentifier = "DetailVC"
    
    @IBOutlet weak var verbTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var firstVerb: UILabel!
    @IBOutlet weak var firstVerbReading: UILabel!
    
    @IBOutlet weak var secondVerb: UILabel!
    @IBOutlet weak var secondVerbReading: UILabel!
    
    @IBOutlet weak var meaningsList: UITableView!
    
    @IBOutlet var secondVerbCard: UIButton!
    @IBOutlet var firstVerbCard: UIButton!
    /*
        Parameter passed on HistoryViewController or FavoriteViewController
     */
    var verbReading: String!
    
    var viewModel: DetailViewModel?
    
    private let disposeBag = DisposeBag()
    
    /*
        Result callback for SearchViewController
     */
    var searchDelegate: SearchDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        bindText(viewModel.title, to: verbTitle.rx.text)
        bindText(viewModel.subTitle, to: subTitle.rx.text)
        bindText(viewModel.firstVerb, to: firstVerb.rx.text)
        bindText(viewModel.secondVerb, to: secondVerb.rx.text)
        bindText(viewModel.firstVerbReading, to: firstVerbReading.rx.text)
        bindText(viewModel.secondVerbReading, to: secondVerbReading.rx.text)
        
        viewModel.meanings
            .bind(to: meaningsList.rx.items(cellIdentifier: "MeaningCell", cellType: MeaningCell.self)) { [weak self] (_, item, cell) in
                cell.bind(with: item)
        }.disposed(by: disposeBag)
                
        firstVerbCard.rx.tap
            .bind(to: viewModel.verbItemClicked.mapObserver { 1 })
            .disposed(by: disposeBag)
        
        secondVerbCard.rx.tap
            .bind(to: viewModel.verbItemClicked.mapObserver { 2 })
            .disposed(by: disposeBag)
        
        firstVerbCard.layer.shadowColor = UIColor.black.cgColor
        firstVerbCard.layer.shadowOpacity = 0.15
        firstVerbCard.layer.shadowOffset = .zero
        firstVerbCard.layer.shadowRadius = 4
        
        secondVerbCard.layer.shadowColor = UIColor.black.cgColor
        secondVerbCard.layer.shadowOpacity = 0.15
        secondVerbCard.layer.shadowOffset = .zero
        secondVerbCard.layer.shadowRadius = 4

    }
    
}

struct MeaningListModel {
    let meaning: String?
    let example: String?
    let usage: [String]
}
