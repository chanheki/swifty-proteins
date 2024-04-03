//
//  BaseViewController.swift
//  SharedCommonUI
//
//  Created by Chan on 4/3/24.
//

import UIKit

import SharedExtensions
import SharedDesignSystem

public class NavigationBar: UIView {
    var backButton = UIButton()
    var titleLabel = UILabel()
    var addButton = UIButton()
    var moreButton = UIButton()
    var doneButton = UIButton()
    var searchController: UISearchController?
    
    public func configureSearchController(delegate: UISearchResultsUpdating, navigationItem: UINavigationItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = delegate
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Ligands"
        self.searchController = searchController // NavigationBar에 searchController 설정
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        // definesPresentationContext는 뷰 컨트롤러에서 설정해야 합니다.
        
        searchController.searchBar.barStyle = .default // 또는 .black
        searchController.searchBar.searchBarStyle = .prominent // 또는 .minimal
        searchController.searchBar.barTintColor = .white // 배경색 설정
    }
}

open class BaseViewController<View: UIView>: UIViewController {
    
    private var contentViewTopConstraint: NSLayoutConstraint?
    
    public let backgroundColor: UIColor = .backgroundColor
    public let tintColor: UIColor = .label
    public let titleFont = UIFont.pretendard(ofSize: 16, weight: .medium)
    
    // MARK: - Open
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    public let navigationBar = NavigationBar().then {
        $0.backButton.configuration = .plain()
        $0.backButton.configuration?.image = UIImage(systemName: "chevron.left")
        $0.backButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        $0.addButton.configuration = .plain()
        $0.addButton.configuration?.image = UIImage(systemName: "plus")
        $0.addButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        $0.moreButton.configuration = .plain()
        $0.moreButton.configuration?.image = UIImage(systemName: "ellipsis.circle")
        $0.moreButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        $0.doneButton.configuration = .plain()
        $0.doneButton.configuration?.baseForegroundColor = .label
        $0.doneButton.configuration?.attributedTitle = AttributedString("완료", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.pretendard(ofSize: 16, weight: .semiBold)]))
    }
    
    public let contentView: UIView = View()
    
    // MARK: - Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupProperty()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        view.backgroundColor = .backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setNavigationBarTintColor(tintColor)
        setNavigationBarTitleLabelFont(titleFont)
        setNavigationBarBackButtonHidden(true)
        setNavigationBarMenuButtonHidden(true)
        setNavigationBarDoneButtonHidden(true)
        
        navigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        view.addSubview(navigationBar)
        navigationBar.addSubview(navigationBar.backButton)
        navigationBar.addSubview(navigationBar.titleLabel)
        navigationBar.addSubview(navigationBar.addButton)
        navigationBar.addSubview(navigationBar.moreButton)
        navigationBar.addSubview(navigationBar.doneButton)
        view.addSubview(contentView)
    }
    
    private func setupLayout() {
        // Auto Layout 활성화 비활성화
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.moreButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.doneButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // NavigationBar Layout
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // backButton Layout
        NSLayoutConstraint.activate([
            navigationBar.backButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 20),
            navigationBar.backButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            navigationBar.backButton.widthAnchor.constraint(equalToConstant: 24),
            navigationBar.backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // titleLabel Layout
        NSLayoutConstraint.activate([
            navigationBar.titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            navigationBar.titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
        
        // moreButton Layout
        NSLayoutConstraint.activate([
            navigationBar.moreButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -20),
            navigationBar.moreButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            navigationBar.moreButton.widthAnchor.constraint(equalToConstant: 24),
            navigationBar.moreButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // addButton Layout
        NSLayoutConstraint.activate([
            navigationBar.addButton.trailingAnchor.constraint(equalTo: navigationBar.moreButton.leadingAnchor, constant: -20),
            navigationBar.addButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
            navigationBar.addButton.widthAnchor.constraint(equalToConstant: 24),
            navigationBar.addButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // doneButton Layout
        NSLayoutConstraint.activate([
            navigationBar.doneButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -20),
            navigationBar.doneButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
        ])
        
        // contentView Layout
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.frame.height ?? 0))
        ])
    }
    
    // MARK: - BaseViewController
    
    public func setNavigationBarBackgroundColor(_ color: UIColor?) {
        navigationBar.backgroundColor = color
    }
    
    func setNavigationBarTintColor(_ color: UIColor) {
        navigationBar.backButton.tintColor = color
        navigationBar.addButton.tintColor = color
        navigationBar.moreButton.tintColor = color
    }
    
    public func setNavigationBarSearchControllerHidden(_ hidden: Bool) {
        
    }
    
    public func setNavigationBarHidden(_ hidden: Bool) {
        navigationBar.isHidden = hidden
        
        // contentView의 상단 제약 조건을 업데이트
        if hidden {
            contentViewTopConstraint?.constant = 0
        } else {
            contentViewTopConstraint?.constant = 60
        }
        
        // 레이아웃 변경을 애니메이션과 함께 적용
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setNavigationBarBackButtonHidden(_ hidden: Bool) {
        navigationBar.backButton.isHidden = hidden
        
        // titleLabel의 제약 조건을 동적으로 업데이트하기 위한 기존 제약 조건 제거
        navigationBar.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(navigationBar.titleLabel.constraints)
        
        if hidden {
            // backButton이 숨겨져 있을 때 titleLabel의 제약 조건 업데이트
            NSLayoutConstraint.activate([
                navigationBar.titleLabel.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 30),
                navigationBar.titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
            ])
        } else {
            // backButton이 보여질 때 titleLabel의 제약 조건 업데이트
            NSLayoutConstraint.activate([
                navigationBar.titleLabel.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
                navigationBar.titleLabel.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor)
            ])
        }
    }
    
    func setNavigationBarMenuButtonHidden(_ hidden: Bool) {
        navigationBar.addButton.isHidden = hidden
        navigationBar.moreButton.isHidden = hidden
    }
    
    func setNavigationBarAddButtonHidden(_ hidden: Bool) {
        navigationBar.addButton.isHidden = hidden
        
        navigationBar.addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(navigationBar.addButton.constraints)
        
        if !hidden {
            // addButton의 제약 조건을 업데이트하여 적절한 위치에 배치
            NSLayoutConstraint.activate([
                navigationBar.addButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -20),
                navigationBar.addButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor),
                navigationBar.addButton.widthAnchor.constraint(equalToConstant: 24),
                navigationBar.addButton.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
    }
    
    func setNavigationBarDoneButtonHidden(_ hidden: Bool) {
        navigationBar.doneButton.isHidden = hidden
    }
    
    func setSearchControllerHidden(_ hidden: Bool) {
        navigationBar.searchController?.searchBar.isHidden = hidden
        // 필요에 따라 추가적인 레이아웃 조정
    }
    
    func setNavigationBarAddButtonAction(_ selector: Selector) {
        navigationBar.addButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    func setNavigationBarMoreButtonAction(_ selector: Selector) {
        navigationBar.moreButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    func setNavigationBarDoneButtonAction(_ selector: Selector) {
        navigationBar.doneButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    func setNavigationBarTitleLabelText(_ text: String?) {
        navigationBar.titleLabel.text = text
    }
    
    func setNavigationBarTitleLabelFont(_ font: UIFont?) {
        navigationBar.titleLabel.font = font
    }
    
    func setNavigationBarTitleLabelTextColor(_ color: UIColor?) {
        navigationBar.titleLabel.textColor = color
    }
    
    // MARK: - Action Functions
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
