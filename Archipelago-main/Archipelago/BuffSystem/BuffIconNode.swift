//
//  BuffIconNode.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/25/22.
//

import UIKit
import SpriteKit

class BuffIconNode: SKSpriteNode {
    
    private var descriptionPanel: SKSpriteNode!
    private var buff: BuffObject!
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildDescriptionPanel(buff: BuffObject) {
        self.buff = buff
        if descriptionPanel == nil {
            descriptionPanel = SKSpriteNode(color: UIColor.black, size: CGSize(width: 120, height: 60))
            descriptionPanel.alpha = 0.9
            descriptionPanel.zPosition = self.zPosition + 1
            descriptionPanel.position = CGPoint(x: 60, y: -57)
            let descriptionNameLabel = SKLabelNode(text: buff.descriptionName())
            descriptionNameLabel.fontName = AppFont.font
            descriptionNameLabel.fontSize = FontSize.buffDescription
            descriptionNameLabel.fontColor = UIColor.white
            descriptionPanel.addChild(descriptionNameLabel)
            descriptionNameLabel.position = CGPoint(x: 0, y: 5)
            let descriptionStackLabel = SKLabelNode(text: buff.descriptionStack())
            descriptionStackLabel.name = "stackLabel"
            descriptionStackLabel.fontName = AppFont.font
            descriptionStackLabel.fontSize = FontSize.buffDescription
            descriptionStackLabel.fontColor = UIColor.white
            descriptionPanel.addChild(descriptionStackLabel)
            descriptionStackLabel.position = CGPoint(x: 0, y: -25)
            self.addChild(descriptionPanel)
        }
        descriptionPanel.isHidden = true
    }
    
    func showDescriptionPanel() {
        descriptionPanel.children.forEach {
            if $0.name == "stackLabel" {
                guard let stackLabel = $0 as? SKLabelNode else {return}
                stackLabel.text = buff.descriptionStack()
            }
        }
        descriptionPanel.isHidden = false
    }
    
    func hideDescriptionPanel() {
        descriptionPanel.isHidden = true
    }
    
    func isDescriptionPanelHidden() -> Bool {
        return descriptionPanel.isHidden
    }
}
