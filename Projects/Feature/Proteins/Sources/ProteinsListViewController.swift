//
//  ProteinsListViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/2/24.
//

import UIKit
import Combine

import SharedCommonUI
import CoreCoreDataProvider
import DomainProteins
import FeatureAuthenticationInterface
import FeatureProteinsInterface
import FeatureAuthentication
import FeatureSettings

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
            viewModel.$filteredLigands
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    guard self != nil else { return }
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
    
    private func setupNavigationBar() -> UIViewController {
        let _ = UINavigationController(rootViewController: self)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .foregroundColor
        self.navigationController?.navigationBar.barTintColor = .foregroundColor
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.foregroundColor]
        self.navigationController?.navigationBar.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.configureSearchController(delegate: self, navigationItem: navigationItem)
        
        self.setupUserButtonView()
        
        return self.navigationController!
    }
    
    private func setupUserButtonView() {
        self.userButtonView = UserButtonView()
        self.userButtonView.addTarget(self, action: #selector(userButtonTapped), for: .touchUpInside)
        
        let userBarButtonItem = UIBarButtonItem(customView: self.userButtonView)
        
        self.navigationItem.rightBarButtonItem = userBarButtonItem
    }
    
    public func initialView() -> UIViewController {
        return self.setupNavigationBar()
    }
    
    public func configureSearchController(delegate: UISearchResultsUpdating, navigationItem: UINavigationItem) {
        let searchbar =  UISearchController(searchResultsController: nil)
        searchbar.searchResultsUpdater = delegate
        searchbar.obscuresBackgroundDuringPresentation = false
        searchbar.searchBar.placeholder = "Search Ligands"
        navigationItem.searchController = searchbar
    }
    
    private func promptForPassword() {
        let passwordVerifyViewController = PasswordVerifyViewController()
        passwordVerifyViewController.verificationDelegate = self
        passwordVerifyViewController.modalPresentationStyle = .automatic
        self.present(passwordVerifyViewController, animated: true, completion: nil)
    }
    
    @objc private func userButtonTapped() {
        AppStateManager.shared.isShowPasswordPrompt = true
        let authenticationFlow = AuthenticationFlow()
        authenticationFlow.authenticateUser { [weak self] success, error in
            if success {
                self?.passwordVerificationDidFinish(success: true)
            } else {
                self?.promptForPassword()
            }
        }
    }
}

extension ProteinsListViewController {
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel?.searchLigands(with: searchController.searchBar.text ?? "")
    }
}

extension ProteinsListViewController: ProteinsListTableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionKey = viewModel?.sectionTitles[indexPath.section] else {
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

extension ProteinsListViewController: PasswordVerifyViewControllerDelegate {
    // PasswordVerifyViewControllerDelegate
    public func passwordVerificationDidFinish(success: Bool) {
        if success {
            let settingViewController = SettingsViewController()
            navigationController?.pushViewController(settingViewController, animated: true)
        }
        AppStateManager.shared.isShowPasswordPrompt = false
    }
}
