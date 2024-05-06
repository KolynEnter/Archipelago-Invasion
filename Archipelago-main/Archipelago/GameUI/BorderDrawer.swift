//
//  BorderDrawer.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/10/23.
//

import SpriteKit

extension SKSpriteNode {

    func drawBorder(color: UIColor, width: CGFloat) {
        for layer in self.children {
            if layer.name == "border" {
                layer.removeFromParent()
            }
        }
        let imageSize = self.size
        let lineWidth = (imageSize.width / self.size.width) * width
        let shapeNode = SKShapeNode(rect: CGRect(x: -imageSize.width/2, y: -imageSize.height/2, width: imageSize.width, height: imageSize.height))
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = lineWidth
        shapeNode.name = "border"
        shapeNode.zPosition = 1001
        self.addChild(shapeNode)
        self.zPosition = 1000
    }
 
}
