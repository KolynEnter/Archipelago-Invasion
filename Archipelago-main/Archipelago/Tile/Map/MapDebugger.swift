//
//  MapDebugger.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/22/23.
//

import SpriteKit

// Assign a different color on each row to a map to debug rotation issue
// Assign row & col to each tile

class MapDebugger {
    
    private var mapCreator: MapCreator
    var debugMask: SKSpriteNode!
    
    init(mapCreator: MapCreator) {
        self.mapCreator = mapCreator
        //debugMask = debugPurposeMapColorMask()
    }
    
    func landscapeRotation() {
        let action = SKAction.rotate(byAngle: CGFloat.pi/2, duration: 0)
        debugMask.run(action)
    }
    
    func portraitRotation() {
        let action = SKAction.rotate(byAngle: -CGFloat.pi/2, duration: 0)
        debugMask.run(action)
    }
    /*
    private func debugPurposeMapColorMask() -> SKSpriteNode {
        let edgeLength = mapCreator.getEdgeLength()
        let row = mapCreator.getRow()
        let col = mapCreator.getCol()
        
        let board = SKSpriteNode(color: UIColor.clear, size: CGSize(width: edgeLength * row, height: edgeLength * col))
        var color: UIColor!
        for i in 0 ..< row {
            color = UIColor.random()
            for j in 0 ..< col {
                let moveSquare = SKSpriteNode(color: UIColor.white, size: CGSize(width: edgeLength, height: edgeLength))
                moveSquare.colorBlendFactor = 0.5
                moveSquare.alpha = 0.2
                moveSquare.color = color
                moveSquare.zPosition = zPositions.selectionMarker
                moveSquare.position = CGPoint(x: (-row/2 + i)*edgeLength, y: (-col/2 + j)*edgeLength)
                moveSquare.position = moveSquare.position + CGPoint(x: CGFloat(edgeLength/2), y: CGFloat(edgeLength/2))
                board.addChild(moveSquare)
            }
        }
        board.position = mapCreator.normalMap.position
        return board
    }
    
    func rowColLabelForTiles(position: CGPoint) -> SKLabelNode {
        let positionLabel = SKLabelNode(text: "(\(mapCreator.getRowColOnMap(objectLocation: position).x), \(mapCreator.getRowColOnMap(objectLocation: position).y))")
        positionLabel.fontName = "Courier New"
        positionLabel.fontSize = 300
        positionLabel.zPosition = 20
        positionLabel.fontColor = .cyan
        return positionLabel
    }
     */
}

// https://stackoverflow.com/questions/29779128/how-to-make-a-random-color-with-swift

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

/*
Create a map with sprite nodes
for i in 0 ..< map.count {
    for j in 0 ..< map[i].count {
        if map[i][j].tileName == "tile5" {
            normalMap.addChild(animatedPortal(x: map[i][j].x, y: map[i][j].y))
            continue
        }
        let t = SKSpriteNode(texture: TextureManager.sharedInstance.getTexture(withName: map[i][j].gameTexture.textureName))
        t.position = CGPoint(x: map[i][j].x, y: map[i][j].y)
        t.zPosition = -1
        //t.addChild(mapDebugger.rowColLabelForTiles(position: t.position))
        normalMap.addChild(t)
    }
}

for i in 0 ..< map.count {
    for j in 0 ..< map[i].count {
        if map[i][j].tileName == "tile5" {
            rotatedMap.addChild(animatedPortal(x: map[i][j].x, y: map[i][j].y))
            continue
        }
        let t = SKSpriteNode(texture: TextureManager.sharedInstance.getTexture(withName: map[i][j].gameTexture.textureName))
        t.position = CGPoint(x: map[i][j].x, y: map[i][j].y)
        t.zPosition = -1
        t.run(SKAction.rotate(byAngle: -CGFloat.pi/2, duration: 0))
        //t.addChild(mapDebugger.rowColLabelForTiles(position: t.position))
        rotatedMap.addChild(t)
    }
}
*/
