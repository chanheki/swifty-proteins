//
//  HelixAnimationView.swift
//  SharedDesignSystem
//
//  Created by Chan on 5/29/24.
//

import UIKit

import Lottie

import SharedExtensions

public let HelixAnimationView: LottieAnimationView = {
    guard let animation = LottieAnimation.named("helix") else {
        fatalError("Failed to load Lottie animation: helix")
    }
    
    let lottieAnimationView = LottieAnimationView(animation: animation)
    lottieAnimationView.backgroundColor = .backgroundColor
    
    lottieAnimationView.mainThreadRenderingEngineShouldForceDisplayUpdateOnEachFrame = true
    
    return lottieAnimationView
}()
