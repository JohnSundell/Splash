//
//  ThemeName.swift
//  SplashImageGen
//
//  Created by Maciej Gad on 23/09/2018.
//

import Foundation
import Splash

public enum ThemeName:String {
    case sundellsColors
    case midnight
    case wwdc17
    case wwdc18
    case sunset
    case presentation
}


extension ThemeName {
    public func theme(withFont font: Splash.Font) -> Splash.Theme {
        switch self {
            case .sundellsColors:
                return Theme.sundellsColors(withFont:font)
            case .midnight:
                return Theme.midnight(withFont:font)
            case .wwdc17:
                return Theme.wwdc17(withFont:font)
            case .wwdc18:
                return Theme.wwdc18(withFont:font)
            case .sunset:
                return Theme.sunset(withFont:font)
            case .presentation:
                return Theme.presentation(withFont:font)
        }
    }
}
