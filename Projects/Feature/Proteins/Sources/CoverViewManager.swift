//
//  CoverViewManager.swift
//  SharedCommonUI
//
//  Created by Chan on 5/23/24.
//

import UIKit

public final class CoverViewManager {
    private var window: UIWindow?
    private var coverView: CoverView?

    public init(window: UIWindow?) {
        self.window = window
    }

    public func addCoverView() {
        if let window = window, coverView == nil {
            let coverView = CoverView(frame: window.bounds)
            window.addSubview(coverView)
            self.coverView = coverView
        }
    }

    public func removeCoverView() {
        coverView?.removeFromSuperview()
        coverView = nil
    }

    public func hasCoverView() -> Bool {
        return coverView != nil
    }
}
