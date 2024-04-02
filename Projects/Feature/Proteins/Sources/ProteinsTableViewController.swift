//
//  ProteinsTableViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/2/24.
//

import UIKit

import Domain
import Shared

public class ProteinsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var proteinsTableView: ProteinsListTableView!
    var viewModel: LigandsViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        proteinsTableView = ProteinsListTableView(frame: self.view.bounds, style: .plain)
        self.view.addSubview(proteinsTableView)

        viewModel = LigandsViewModel()

        proteinsTableView.dataSource = self
        proteinsTableView.delegate = self
        
        proteinsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LigandCell")
        
        // 레이아웃 조정이 필요한 경우 여기에 추가
        proteinsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            proteinsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            proteinsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            proteinsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            proteinsTableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ligands.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LigandCell", for: indexPath)
        let ligand = viewModel.ligands[indexPath.row]
        cell.textLabel?.text = ligand.identifier
        return cell
    }


    // UITableViewDelegate 메서드 구현 (선택적)
    // 여기에 셀 선택 처리 등을 추가할 수 있음
}
