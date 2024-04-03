//
//  Font.swift
//  SharedDesignSystem
//
//  Created by Chan on 4/3/24.
//

import UIKit

public extension UIFont {
    
    // pretendard 폰트 적용 함수
    static func pretendard(ofSize fontSize: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: weight.pretendardFontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    // tenada 폰트 적용 함수
    static func tenada(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Tenada", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

// 폰트 무게와 관련된 enum과 UIFont 이름을 반환하는 확장
public extension UIFont {
    enum FontWeight {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case semiBold
        case thin
        
        // 해당 FontWeight에 따른 pretendard 폰트 이름 반환
        var pretendardFontName: String {
            switch self {
            case .black:
                return "Pretendard-Black"
            case .bold:
                return "Pretendard-Bold"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .extraLight:
                return "Pretendard-ExtraLight"
            case .light:
                return "Pretendard-Light"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .thin:
                return "Pretendard-Thin"
            }
        }
    }
}
