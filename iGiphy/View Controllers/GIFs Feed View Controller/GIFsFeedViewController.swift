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
        setupActivityIndicator()
    }
    
    private func setupSearchBar() {
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = .babyPurple
        searchBar.backgroundImage = UIImage()
        searchBar.setTextFieldBackgroundColor(.white)
        searchForGiftsOn(searchBar.rx.text.orEmpty)
        resignSearchBarAsFirstResponder(event: searchBar.rx.searchButtonClicked)
    }
    
    private func searchForGiftsOn(_ event: ControlProperty<String>) {
        event.filter( { !$0.isEmpty })
        .distinctUntilChanged()
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] text in
            self?.viewModel.searchForGifs(query: text)
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.contentInset = tableContentInset
        tableView.separatorStyle = .none
        tableView.registerCellFromNib(named: GifTableViewCell.identifier)
        bindGifListToTableView(gifList: viewModel.gifList)
        resignSearchBarAsFirstResponder(event: tableView.rx.didScroll)
    }
    
    private func bindGifListToTableView(gifList: Observable<[GifViewModel]>) {
        gifList.asObservable().bind(to: tableView.rx.items(cellIdentifier: GifTableViewCell.identifier)) { [weak self] index, gifViewModel, cell in
            if let cell = cell as? GifTableViewCell {
                cell.configure(viewModel: gifViewModel)
                cell.favouriteButton.rx.tap
                    .asDriver()
                    .drive(onNext: {
                        self?.viewModel.toggleFavourite(id: gifViewModel.id)
                    }).disposed(by: cell.disposeBag )
            }
        }.disposed(by: disposeBag)
    }
    
    private func resignSearchBarAsFirstResponder(event: ControlEvent<Void>) {
        event.subscribe(onNext: { [weak self] in self?.searchBar.resignFirstResponder() } ).disposed(by: disposeBag)
    }
    
    private func setupActivityIndicator() {
        viewModel.isLoading.bind(to: activityIndicator.rx.isAnimating).disposed(by: disposeBag)
    }
    
}
