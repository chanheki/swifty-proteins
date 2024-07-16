//
//  CoverViewManager.swift
//  SharedCommonUI
//
//  Created by Chan on 5/23/24.
//

import UIKit

import CoreCoreDataProvider
import SharedDesignSystem

public final class CoverViewManager {
    private var window: UIWindow?
    private var coverView: CoverView?
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    public func addCoverView() {
        if AppStateManager.shared.isPossibleCoverView && !AppStateManager.shared.isShowPasswordPrompt {
            startCoverView()
        }
    }
    
    public func startCoverView() {
        if let window = window, coverView == nil {
            let coverView = CoverView(frame: window.bounds)
            window.addSubview(coverView)
            self.coverView = coverView
        }
    }
    
    public func removeCoverView() {
        guard let coverView = coverView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            coverView.alpha = 0
        }, completion: { _ in
            coverView.removeFromSuperview()
            self.coverView = nil
        })
    }
    
    public func hasCoverView() -> Bool {
        return coverView != nil
    }
}
