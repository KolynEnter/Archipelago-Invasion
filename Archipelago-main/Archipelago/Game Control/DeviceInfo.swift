//
//  DeviceInfo.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/7/23.
//

import SpriteKit

enum DeviceOrientation {
    static let portriat: Int = 0
    static let landscape: Int = 1
}
var currentDeviceOrientation: Int!

// https://stackoverflow.com/questions/25796545/getting-device-orientation-in-swift
/*
struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape :(UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape)!
                // : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait: (UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait)!
                // : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
*/
struct OrientationChecker {
    func landscapeTrue(view: SKView?) -> Bool {
        guard let view = view else {return false}
        return UIDevice.current.orientation.isValidInterfaceOrientation
        ? UIDevice.current.orientation.isLandscape : view.bounds.width >= view.bounds.height
    }
    
    func portraitTrue(view: SKView?) -> Bool {
        guard let view = view else {return false}
        return UIDevice.current.orientation.isValidInterfaceOrientation
        ? UIDevice.current.orientation.isPortrait : view.bounds.width <= view.bounds.height
    }
}
