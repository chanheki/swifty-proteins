//
//  ProteinsTableViewInterface.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import UIKit

protocol ProteinsTableViewProtocol: AnyObject {
    func moveCell(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func openFolderIfNeeded(_ folderIndex: Int)
}
