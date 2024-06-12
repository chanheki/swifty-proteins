//
//  GoogleLogo.swift
//  SharedDesignSystem
//
//  Created by 민영재 on 6/12/24.
//

import UIKit

public let GoogleLogo: UIImage = {
    let bundle = Bundle.module
    guard let image = UIImage(named: "GoogleLogo", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal) else {
        fatalError("Failed to load GoogleLogo image")
    }
    return image
}()
