//
//  Toucher.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/25/22.
//

import SpriteKit

class TouchScene: SKScene {
    var lastTouch = CGPoint.zero
    var originalTouch = CGPoint.zero
    var cameraNode: SKCameraNode!
    var oldCameraScale: CGFloat = 0
    var currentCameraScale: CGFloat = 0 {
        didSet {
            if !floatingPanels.isEmpty {
                floatingPanels.forEach {
                    if currentDeviceOrientation == DeviceOrientation.portriat {
                        $0.setScale(currentCameraScale/UIScale().skillPanelDivisionRatio)
                        let targetPositionX: CGFloat = $0.position.x + 300*oldCameraScale
                        //let targetPositionY: CGFloat = $0.position.y + 300*oldCameraScale
                        $0.position = CGPoint(x: targetPositionX-(300*currentCameraScale),
                                              y: $0.position.y)
                        $0.setScale($0.xScale*1.5)
                    } else {
                        $0.setScale(currentCameraScale/UIScale().skillPanelDivisionRatio)
                        let targetPositionX: CGFloat = $0.position.x + 200*oldCameraScale
                        //let targetPositionY: CGFloat = $0.position.y + 300*oldCameraScale
                        $0.position = CGPoint(x: targetPositionX-(200*currentCameraScale),
                                              y: $0.position.y)
                    }
                }
            }
        }
    }
    var floatingPanels = [SKSpriteNode]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        lastTouch = touch.location(in: self.view)
        originalTouch = lastTouch
    }
    
    public var frameMidX: CGFloat {
        var result: CGFloat
        if UIDevice.current.userInterfaceIdiom == .phone {
            if currentDeviceOrientation == DeviceOrientation.landscape {
                result = CGFloat(frame.midX)
            } else {
                result = CGFloat(frame.midX)*0.9
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            if currentDeviceOrientation == DeviceOrientation.landscape {
                result = CGFloat(frame.midX)*1.1
            } else {
                result = CGFloat(frame.midX)*1.1
            }
        } else {
            if currentDeviceOrientation == DeviceOrientation.landscape {
                result = CGFloat(frame.midX)
            } else {
                result = CGFloat(frame.midX)
            }
        }
        return result
    }
    
    public var frameMidY: CGFloat {
        var result: CGFloat
        if UIDevice.current.userInterfaceIdiom == .phone {
            if currentDeviceOrientation == DeviceOrientation.landscape {
                result = CGFloat(frame.midY)*0.2
            } else {
                result = CGFloat(frame.midY)*0.8
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            if currentDeviceOrientation == DeviceOrientation.landscape {
                result = CGFloat(frame.midY)*0.3
            } else {
                result = CGFloat(frame.midY)*0.7
            }
        } else {
            if currentDeviceOrientation == DeviceOrientation.landscape {
                result = CGFloat(frame.midY)
            } else {
                result = CGFloat(frame.midY)
            }
        }
        return result
    }
}
