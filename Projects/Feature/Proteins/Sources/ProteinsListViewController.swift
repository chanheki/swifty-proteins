//
//  ProteinsListViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/2/24.
//

import UIKit
import Combine

import FeatureProteinsInterface
import FeatureSettings
import DomainProteins
import SharedCommonUI
import SharedExtensions

public final class ProteinsListViewController: BaseViewController<ProteinsListView>, UISearchResultsUpdating {
    
    private var viewModel: LigandsListViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    private var userButtonView: UserButtonView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.title = "Swifty Proteins"
    }
    
    private func bindViewModel() {
        guard let proteinsView = self.contentView as? ProteinsListView else {
            return
        }
        
        if let viewModel = viewModel {
            // filteredLigands 바인딩 추가
            viewModel.$filteredLigands
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    proteinsView.proteinsTableView.reloadData()
                }
                .store(in: &cancellables)
            
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
            proteinListView.proteinsTableView.selectionDelegate = self
        }
        
        self.view.backgroundColor = .backgroundColor
        
        self.setNavigationBarHidden(true)
        self.setNavigationBarBackgroundColor(.proteins)
        
        self.definesPresentationContext = true
    }
    
    // navigationbar 초기화
    private func setupNavigationBar() -> UIViewController {
        // Navigation Controller 생성
        let _ = UINavigationController(rootViewController: self)
        
        // 네비게이션 바 설정
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .foregroundColor
        self.navigationController?.navigationBar.barTintColor = .foregroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.foregroundColor]
        self.navigationController?.navigationBar.backgroundColor = .backgroundColor
        
        // Title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // search
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        // 네비게이션바에 들어갈 search controller 설정
        self.configureSearchController(delegate: self, navigationItem: navigationItem)
        
        // UserButton 생성
        self.setupUserButtonView()
        
        return self.navigationController!
    }
    
    private func setupUserButtonView() {
        self.userButtonView = UserButtonView()
        self.userButtonView.addTarget(self, action: #selector(userButtonTapped), for: .touchUpInside)
        
        // UserButtonView를 UIBarButtonItem으로 변환
        let userBarButtonItem = UIBarButtonItem(customView: self.userButtonView)
        
        // navigationItem의 rightBarButtonItem으로 설정
        self.navigationItem.rightBarButtonItem = userBarButtonItem
    }
    
    // 현재 프로틴 리스트 컨트롤러를 네비게이션 컨트롤러의 루트로 설정
    public func initialView() -> UIViewController {
        return self.setupNavigationBar()
    }
    
    // SearchController 초기화
    public func configureSearchController(delegate: UISearchResultsUpdating, navigationItem: UINavigationItem) {
        let searchbar =  UISearchController(searchResultsController: nil)
        searchbar.searchResultsUpdater = delegate
        searchbar.obscuresBackgroundDuringPresentation = false
        searchbar.searchBar.placeholder = "Search Ligands"
        navigationItem.searchController = searchbar
    }
    
    @objc private func userButtonTapped() {
        let settingViewController = SettingsViewController()
        
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}

extension ProteinsListViewController {
    // 검색 결과 업데이트 로직
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel?.searchLigands(with: searchController.searchBar.text ?? "")
    }
}

extension ProteinsListViewController: ProteinsListTableViewDelegate {
    // ProteinsListTableViewDelegate 구현
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionKey = viewModel?.sectionTitles[indexPath.section] else {
            // 에러처리뷰 만들어서 넣을 것
            navigationController?.pushViewController(UIViewController(), animated: true)
            return
        }
        
        if let ligand = viewModel?.ligandsBySection[sectionKey]?[indexPath.row] {
            let proteinsViewController = ProteinsViewController()
            
            self.title = ligand.identifier
            proteinsViewController.ligand = ligand
            proteinsViewController.setNavigationBarTitleLabelText(ligand.identifier)
            navigationController?.pushViewController(proteinsViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 스크롤 뷰 델리게이트 메서드
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleHeight = self.navigationController?.navigationBar.frame.height ?? 0.1
        
        if offsetY > largeTitleHeight {
            self.navigationItem.largeTitleDisplayMode = .never
            self.userButtonView.isLarge = false
        } else {
            self.navigationItem.largeTitleDisplayMode = .always
            self.userButtonView.isLarge = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
        
    }
}
