//
//  ProteinsListViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/2/24.
//

import UIKit

import Shared

public final class ProteinsListViewController: BaseViewController<ProteinsListView>, UISearchResultsUpdating {
    
    public override func setupProperty() {
        self.view.backgroundColor = .backgroundColor
        self.title = "Swifty Proteins"
        
        setNavigationBarHidden(true)
        setNavigationBarBackgroundColor(.proteins)
    }
    
    public func initialView() -> UIViewController {
        // 현재 프로틴 리스트 컨트롤러를 네비게이션 컨트롤러의 루트로 설정
        let initialViewController = self.setupSearchBar()
        
        return initialViewController
    }
    
    private func setupSearchBar() -> UIViewController {
        navigationBar.configureSearchController(delegate: self, navigationItem: navigationItem)
        
        definesPresentationContext = true
        
        let searchBarController = UINavigationController(rootViewController: self)
        
        // 네비게이션 바 설정
        searchBarController.navigationBar.prefersLargeTitles = true
        searchBarController.navigationBar.isTranslucent = true
        searchBarController.navigationBar.barTintColor = .blue
        searchBarController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        searchBarController.navigationBar.backgroundColor = .backgroundColor
        return searchBarController
    }
}

// UISearchResultsUpdating 프로토콜을 확장하여 검색 결과 업데이트 로직을 구현합니다.
extension ProteinsListViewController {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            // 검색 텍스트가 없는 경우의 처리 로직 (예: 모든 데이터를 다시 표시)
            return
        }
        
    }
}
