//
//  ProteinsListViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/2/24.
//

import UIKit
import Combine

import DomainProteins
import Shared

public final class ProteinsListViewController: BaseViewController<ProteinsListView>, UISearchResultsUpdating {
    
    private var viewModel: LigandsViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        guard let proteinsView = self.contentView as? ProteinsListView else {
            return
        }
        
        if let viewModel = viewModel {
            viewModel.$ligandsBySection
                .receive(on: RunLoop.main)
                .sink { _ in
                    proteinsView.proteinsTableView.reloadData()
                }
                .store(in: &cancellables)
        }
    }
    
    public override func setupProperty() {
        if let proteinListView = self.contentView as? ProteinsListView {
            viewModel = proteinListView.viewModel
        }
        
        self.view.backgroundColor = .backgroundColor
        self.title = "Swifty Proteins"
        
        self.setNavigationBarHidden(true)
        self.setNavigationBarBackgroundColor(.proteins)
        
        self.configureSearchController(delegate: self, navigationItem: navigationItem)
        
        self.definesPresentationContext = true
    }
    
    // SearchBar 초기화
    private func setupSearchBar() -> UIViewController {
        let searchBarController = UINavigationController(rootViewController: self)
        
        // 네비게이션 바 설정
        searchBarController.navigationBar.prefersLargeTitles = true
        searchBarController.navigationBar.isTranslucent = true
        searchBarController.navigationBar.barTintColor = .blue
        searchBarController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        searchBarController.navigationBar.backgroundColor = .backgroundColor
        return searchBarController
    }
    
    // 현재 프로틴 리스트 컨트롤러를 네비게이션 컨트롤러의 루트로 설정
    public func initialView() -> UIViewController {
        return self.setupSearchBar()
    }
    
    // SearchController 초기화
    public func configureSearchController(delegate: UISearchResultsUpdating, navigationItem: UINavigationItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Ligands"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// 검색 결과 업데이트 로직
extension ProteinsListViewController {
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel?.searchLigands(with: searchController.searchBar.text ?? "")
    }
}
