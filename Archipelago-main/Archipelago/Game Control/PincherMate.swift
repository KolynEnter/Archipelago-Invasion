//
//  PincherMate.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/9/23.
//

import SpriteKit

enum PincherMate {
    case mapLandscapeMin
    case mapPortraitMin
    case mapLandscapeMax
    case mapPortraitMax
    
    var val: CGFloat {
        get {
            switch self {
            case .mapLandscapeMin:
                return 6
            case .mapPortraitMin:
                return 3.44
            case .mapLandscapeMax:
                return 12
            case .mapPortraitMax:
                return 9.5
            }
        }
    }
}
