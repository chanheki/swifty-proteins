//
//  ProteinsTableViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/2/24.
//

import UIKit

import Shared

public class ProteinsListViewController: BaseViewController<ProteinsListView>, UISearchResultsUpdating {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarBackgroundColor(.proteins)
        navigationBar.configureSearchController(delegate: self, navigationItem: navigationItem)
        definesPresentationContext = true
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
