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

    private(set) var loadMoreThreshold = 0.75
    private let tableContentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    private let disposeBag = DisposeBag()
    
    var viewModel: GIFListViewModeling = GIFListViewModel()
    
    static func instantiate(viewModel: GIFListViewModel) -> GIFsFeedViewController {
        let storyboard = UIStoryboard.main
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! GIFsFeedViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.fetchTrendingGIFList()
    }

    private func setupViews() {
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
    }
    
    private func setupSearchBar() {
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = .babyPurple
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldBackgroundColor(.white)
        searchForGIFtsOn(searchBar.rx.text.orEmpty)
        resignSearchBarAsFirstResponder(onEvent: searchBar.rx.searchButtonClicked)
    }
    
    private func searchForGIFtsOn(_ event: ControlProperty<String>) {
        event.filter( { !$0.isEmpty })
        .distinctUntilChanged()
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] text in
            self?.viewModel.searchForGIFs(query: text)
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.contentInset = tableContentInset
        tableView.separatorStyle = .none
        tableView.registerCellFromNib(named: GIFTableViewCell.identifier)
        bindGIFListToTableView(viewModel.gifList)
        resignSearchBarAsFirstResponder(onEvent: tableView.rx.didScroll)
    }
    
    private func bindGIFListToTableView( _ gifList: Observable<[GIFViewModel]>) {
        gifList.bind(to: tableView.rx.items(cellIdentifier: GIFTableViewCell.identifier)) { [weak self] index, gifViewModel, cell in
            if let cell = cell as? GIFTableViewCell {
                cell.configure(viewModel: gifViewModel)
                self?.bindFavouriteButton(cell, viewModel: gifViewModel)
                self?.bindShareButton(cell, viewModel: gifViewModel)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindFavouriteButton(_ cell: GIFTableViewCell, viewModel: GIFViewModel) {
        cell.favouriteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.toggleFavourite(id: viewModel.id)
            }).disposed(by: cell.disposeBag )
    }
    
    private func bindShareButton(_ cell: GIFTableViewCell, viewModel: GIFViewModel) {
        cell.shareButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = viewModel.url else {
                    return
                }
                let items = [url]
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self?.present(activityViewController, animated: true)
            }).disposed(by: cell.disposeBag )
    }
    
    private func resignSearchBarAsFirstResponder(onEvent event: ControlEvent<Void>) {
        event.subscribe(onNext: { [weak self] in self?.searchBar.resignFirstResponder() } ).disposed(by: disposeBag)
    }
    
    private func setupActivityIndicator() {
        viewModel.isLoading.bind(to: activityIndicator.rx.isAnimating).disposed(by: disposeBag)
    }
    
}
