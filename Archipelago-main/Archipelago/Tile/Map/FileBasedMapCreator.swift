//
//  FileBasedMapCreator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/20/23.
//

import SpriteKit

class FileBasedMapCreator: MapCreator {

    override init() {
        super.init()
    }
    
    func fileBasedMap(mapName: String, rotatedReverseNinty: Bool) -> SKNode {
        let mapNode = SKNode()
        feedNonvisualMap(mapName: mapName)
        
        TextureManager.sharedInstance.removeAllTextures()
        TextureManager.sharedInstance.addTextures(withNames: [
            TileTextures.LandOne.textureName,
            TileTextures.LandTwo.textureName
        ])
        TextureManager.sharedInstance.preloadAllTextures()
        
        var tileType: SKTileSet!
        if !rotatedReverseNinty {
            tileType = assignTileType(tileNames: [
                TileTextures.LandOne.textureName,
                TileTextures.LandTwo.textureName
            ])
        } else {
            tileType = assignRotatedTileType(tileNames: [
                TileTextures.LandOne.textureName,
                TileTextures.LandTwo.textureName
            ])
        }
        
        let myVisualMap = visualMap(with: tileType)
        myVisualMap.position = CGPoint.zero
        myVisualMap.enableAutomapping = false
        
        mapNode.addChild(myVisualMap)
        mapNode.position = cameraCenter()
        mapNode.zPosition = -1
        return mapNode
    }
    
    func feedNonvisualMap(mapName: String) {
        mapFiller = MapFiller(row: 0, col: 0)
        nonVisualMap = mapFiller.filledMap(with: mapName)
        row = nonVisualMap.count
        col = nonVisualMap[0].count
    }
}
