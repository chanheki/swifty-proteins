//
//  CheckboxAnimationView.swift
//  SharedDesignSystem
//
//  Created by 민영재 on 6/5/24.
//

import UIKit

import Lottie

import SharedExtensions

public let CheckBoxAnimationView: LottieAnimationView = {
    guard let animationView = LottieAnimation.named("checkbox") else {
        fatalError("Failed to load Lottie animation: checkbox")
    }
    
    let lottieAnimationView = LottieAnimationView(animation: animationView)
    lottieAnimationView.backgroundColor = .backgroundColor
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .playOnce
    lottieAnimationView.animationSpeed = 1.0
    
    lottieAnimationView.mainThreadRenderingEngineShouldForceDisplayUpdateOnEachFrame = true
    
    return lottieAnimationView
}()
