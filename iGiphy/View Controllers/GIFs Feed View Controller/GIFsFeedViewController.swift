//
//  GIFsFeedViewController.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import UIKit
import RxSwift
import RxCocoa

class GIFsFeedViewController: UIViewController {

    @IBOutlet private(set) weak var searchBar: UISearchBar!
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var activityIndicator: UIActivityIndicatorView!

    private let tableContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    private let disposeBag = DisposeBag()
    
    var viewModel: GifListViewModeling = GifListViewModel()
    
    static func instantiate(viewModel: GifListViewModel) -> GIFsFeedViewController {
        let storyboard = UIStoryboard.main
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! GIFsFeedViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.fetchTrendingGifList()
    }

    private func setupViews() {
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = .babyPurple
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldBackgroundColor(.white)
        searchBar.rx.text.orEmpty
            .filter( { !$0.isEmpty })
            .distinctUntilChanged()
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.searchForGifs(query: text)
            }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.contentInset = tableContentInset
        tableView.registerCellFromNib(named: GifTableViewCell.identifier)
        viewModel.gifList.asObservable().bind(to: tableView.rx.items(cellIdentifier: GifTableViewCell.identifier)) { index, viewModel, cell in
            if let cell = cell as? GifTableViewCell {
                cell.configure(viewModel: viewModel)
            }
        }.disposed(by: disposeBag)
    }
    
}
