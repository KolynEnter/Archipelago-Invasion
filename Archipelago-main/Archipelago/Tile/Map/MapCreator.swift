//
//  MapCreator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/26/22.
//

import SpriteKit
import GameplayKit

class MapCreator {
    var edgeLength = 1024
    var nonVisualMap = [[TileObject]]()
    var nonVisualMapOverlay = [[TileObject]]() // Handle changable tiles, animating tiles
    var mapFiller: MapFiller!
    var row: Int = 0
    var col: Int = 0

    func visualMap(with tileType: SKTileSet) -> SKTileMapNode {
        let col = nonVisualMap.count
        let row = nonVisualMap[0].count

        let bgNode = SKTileMapNode(tileSet: tileType,
                                   columns: col,
                                   rows: row,
                                   tileSize: CGSize(width: edgeLength, height: edgeLength))
        
        for i in 0 ..< col {
            for j in 0 ..< row {
                if nonVisualMap[i][j].gameTexture.textureName == TileTextures.Portal.textureName {
                    let tile = bgNode.tileSet.tileGroups.first (where: {$0.name! == TileTextures.Empty.textureName})
                    bgNode.setTileGroup(tile, forColumn: i, row: j)
                    continue
                }
                    
                let tile = bgNode.tileSet.tileGroups.first (where: {$0.name! == nonVisualMap[i][j].gameTexture.textureName})
                bgNode.setTileGroup(tile, forColumn: i, row: j)
            }
        }
        
        bgNode.position = cameraCenter()
        return bgNode
    }
    
    func visualMapOverlay() -> SKNode {
        let result = SKNode()
        let col = nonVisualMapOverlay.count
        var row: Int
        if !nonVisualMapOverlay.isEmpty {
            row = nonVisualMapOverlay[0].count
        } else {
            row = 0
        }
        
        for i in 0 ..< col {
            for j in 0 ..< row {
                if nonVisualMapOverlay[i][j].x != -1 && nonVisualMapOverlay[i][j].y != -1 {
                    if nonVisualMapOverlay[i][j].gameTexture.textureName == TileTextures.Portal.textureName {
                        let t = animatedPortal(x: nonVisualMapOverlay[i][j].x, y: nonVisualMapOverlay[i][j].y)
                        t.zPosition = 10
                        result.addChild(t)
                        continue
                    }
                    let t = SKSpriteNode(texture: TextureManager.sharedInstance.getTexture(withName: nonVisualMapOverlay[i][j].gameTexture.textureName))
                    t.position = CGPoint(x: nonVisualMapOverlay[i][j].x, y: nonVisualMapOverlay[i][j].y)
                    t.zPosition = 10
                    result.addChild(t)
                }
            }
        }
        
        return result
    }
    
    func visualMapOverlayRotated() -> SKNode {
        let result = SKNode()
        let col = nonVisualMapOverlay.count
        var row: Int
        if !nonVisualMapOverlay.isEmpty {
            row = nonVisualMapOverlay[0].count
        } else {
            row = 0
        }
        
        for i in 0 ..< col {
            for j in 0 ..< row {
                if nonVisualMapOverlay[i][j].x != -1 && nonVisualMapOverlay[i][j].y != -1 {
                    if nonVisualMapOverlay[i][j].gameTexture.textureName == TileTextures.Portal.textureName {
                        let t = animatedPortal(x: nonVisualMapOverlay[i][j].x, y: nonVisualMapOverlay[i][j].y)
                        t.zPosition = 10
                        t.run(SKAction.rotate(byAngle: -CGFloat.pi/2, duration: 0))
                        result.addChild(t)
                        continue
                    }
                    let t = SKSpriteNode(texture: TextureManager.sharedInstance.getTexture(withName: nonVisualMapOverlay[i][j].gameTexture.textureName))
                    t.position = CGPoint(x: nonVisualMapOverlay[i][j].x, y: nonVisualMapOverlay[i][j].y)
                    t.zPosition = 10
                    t.run(SKAction.rotate(byAngle: -CGFloat.pi/2, duration: 0))
                    result.addChild(t)
                }
            }
        }
        
        return result
    }
    
    private func animatedPortal(x: CGFloat, y: CGFloat) -> SKSpriteNode {
        let rotate = SKAction.rotate(byAngle: -CGFloat.pi, duration: 5)
        let repeatForever = SKAction.repeatForever(rotate)
        let portal = SKSpriteNode(texture: TextureManager.sharedInstance.getTexture(withName: TileTextures.Portal.textureName))
        portal.run(repeatForever)
        portal.zPosition = 1
        portal.position = CGPoint(x: x, y: y)
        portal.zPosition = 0
        return portal
    }
    
    func assignTileType(tileNames: [String]) -> SKTileSet {
        let tileType = SKTileSet()
        
        for i in 0 ..< tileNames.count {
            guard let tileTex = TextureManager.sharedInstance.getTexture(withName: tileNames[i]) else {continue}
            let tileDefin = SKTileDefinition(texture: tileTex)
            let bgGroup = SKTileGroup(tileDefinition: tileDefin)
            bgGroup.name = tileNames[i]
            tileType.tileGroups.append(bgGroup)
        }
        
        return tileType
    }
    
    func assignRotatedTileType(tileNames: [String]) -> SKTileSet {
        let tileType = SKTileSet()
        
        for i in 0 ..< tileNames.count {
            guard let tileTex = TextureManager.sharedInstance.getTexture(withName: tileNames[i]) else {continue}
            let tileDefin = SKTileDefinition(texture: tileTex)
            tileDefin.rotation = .rotation270
            let bgGroup = SKTileGroup(tileDefinition: tileDefin)
            bgGroup.name = tileNames[i]
            tileType.tileGroups.append(bgGroup)
        }
        
        return tileType
    }
    
    func squarePositionIsInBoard(position: CGPoint) -> Bool{
        let x = position.x
        let y = position.y
        if x < 0 || y < 0 {
            return false
        }
        
        let row = (Int(x) - edgeLength/2) / edgeLength
        let col = (edgeLength*getCol() - (Int(y)+edgeLength/2)) / edgeLength
        
        if col < 0 || col >= getCol() {return false}
        if row < 0 || row >= getRow() {return false}
        return nonVisualMap[row][col].x == x && nonVisualMap[row][col].y == y
    }

    func getEdgeLength() -> Int {
        return edgeLength
    }
    
    func getRow() -> Int {
        return row
    }
    
    func getCol() -> Int {
        return col
    }

    func cameraCenter() -> CGPoint {
        return CGPoint(x: getRow() * edgeLength / 2, y: getCol() * edgeLength / 2)
    }
}
