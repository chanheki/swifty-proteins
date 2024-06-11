//
//  SettingsListTableViewDelegate.swift
//  FeatureSettings
//
//  Created by Chan on 6/9/24.
//

import UIKit

public protocol SettingsListTableViewDelegate: AnyObject {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
