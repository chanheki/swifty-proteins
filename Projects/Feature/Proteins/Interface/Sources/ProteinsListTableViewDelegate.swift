//
//  ProteinsListTableViewDelegate.swift
//  FeatureProteinsInterface
//
//  Created by Chan on 6/5/24.
//

import UIKit

public protocol ProteinsListTableViewDelegate: AnyObject {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}
