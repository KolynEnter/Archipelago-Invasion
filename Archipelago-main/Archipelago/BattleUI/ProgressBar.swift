//
//  ProgressBar.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/29/22.
//

import SpriteKit

class ProgressBar: SKNode {
    
    private var progressBar = SKSpriteNode()
    private var progressString = SKLabelNode(fontNamed: AppFont.font)
    
    override init() {
        super.init()
    }
    
    func buildProgressBar() {
        let progressBarContainer = SKSpriteNode(imageNamed: "ProgressBarContainer")
        progressBarContainer.size.width = 400
        progressBarContainer.size.height = 64
        progressBarContainer.position = CGPoint(x: 345, y: 0)
        progressBarContainer.zPosition = 2
        progressBarContainer.texture?.filteringMode = .nearest
        
        progressBar = SKSpriteNode(color: UIColor(white: 0, alpha: 0.8), size: CGSize(width: 133, height: 62))
        progressBar.size.width = 0 // [150, 0]
        progressBar.position = CGPoint(x: 235, y: 0)
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressBar.zPosition = 1
        
        let progressBase = SKSpriteNode(color: UIColor(white: 1, alpha: 0.8), size: CGSize(width: 310, height: 62))
        progressBase.position = CGPoint(x: 235, y: 0)
        progressBase.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressBase.zPosition = 0
        
        progressString.fontSize = FontSize.hpProgressBar
        progressString.position = CGPoint(x: 395, y: -7)
        progressString.horizontalAlignmentMode = .center
        progressString.zPosition = 3
        
        addChild(progressBar)
        addChild(progressBarContainer)
        addChild(progressBase)
        addChild(progressString)
    }
    
    func updateProgressBar(hpCurrent: Float, hpMax: Float) {
        let ratio = Float(100*hpCurrent/hpMax)
        if ratio < 0 || ratio > 100 {return}
        
        let resize = SKAction.resize(toWidth: CGFloat(100-ratio)*3.1, duration: TimeController.regularCameraMovement)
        progressBar.run(resize)
        progressString.text = "\(round(hpCurrent*10)/10.0)/\(round(hpMax*10)/10.0)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
