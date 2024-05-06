//
//  GameMapCreator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/28/23.
//

// step 1: feed the non-visual map
// step 2: create the visual maps

import SpriteKit

class GameMapCreator: MapCreator {
    var normalMap: SKNode!
    var rotatedMap: SKNode!
    var isRotated: Bool = false
    var player: GameUnit!
    var enemies: [GameUnit]!
    private var campRowCol: Point2D!
    private var portalRowCol: Point2D!
    private let perlin = Perlin2D(seed: "Archipelago")
    private var monsterWalkManager: MonsterWalkManager!
    private weak var gameScene: GameScene?
    
    init(gameScene: GameScene) {
        super.init()
        monsterWalkManager = MonsterWalkManager(gameMapCreator: self)
        self.gameScene = gameScene
    }
    
    func generateTownmap() {
        useFileBasedMap(mapName: "townmap")
    }
    
    private func useFileBasedMap(mapName: String) {
        normalMap = SKNode()
        rotatedMap = SKNode()
        nonVisualMap = [[TileObject]](repeating: [TileObject](repeating: LandOne(x: 0, y: 0), count: col), count: row)
        nonVisualMapOverlay = [[TileObject]](repeating: [TileObject](repeating: LandOne(x: -1, y: -1), count: col), count: row)
        mapFiller = MapFiller(row: row, col: col)
        
        let fileMapCreator = FileBasedMapCreator()
        fileMapCreator.feedNonvisualMap(mapName: mapName)
        row = fileMapCreator.row
        col = fileMapCreator.col
        
        self.nonVisualMap = fileMapCreator.nonVisualMap
        self.nonVisualMapOverlay = fileMapCreator.nonVisualMapOverlay
        
        let mapEdgeLength = edgeLength * max(nonVisualMap.count, nonVisualMap[0].count) / 2
        normalMap.position = CGPoint(x: 0, y: 0)
        rotatedMap.position = CGPoint(x: mapEdgeLength*2, y: 0)
        
        // put camp
        campRowCol = Point2D(x: 14, y: 9)
        let campPosition = getPositionOnMap(row: campRowCol.x, col: campRowCol.y)
        nonVisualMap[campRowCol.x][campRowCol.y] = idToTile(id: .Camp, x: campPosition.x, y: campPosition.y)
        
        // put portal to an un-reachable position
        portalRowCol = Point2D(x: -1, y: -1)
        
        TextureManager.sharedInstance.removeAllTextures()
        TextureManager.sharedInstance.addTextures(withNames: [
            TileTextures.LandOne.textureName,
            TileTextures.LandTwo.textureName,
            TileTextures.Camp.textureName,
            TileTextures.TownSign.textureName,
            TileTextures.TownShop.textureName,
            TileTextures.TownInn.textureName,
            TileTextures.AlchemistHouse.textureName,
            TileTextures.Arena.textureName,
            TileTextures.Guild.textureName,
            //TileTextures.Prison.textureName,
            TileTextures.Fence.textureName,
            TileTextures.Water.textureName,
            TileTextures.Mountain.textureName,
            TileTextures.Grass.textureName,
            TileTextures.Tree.textureName
        ])
        TextureManager.sharedInstance.preloadAllTextures()
        
        createVisualMap(textureNames: [
            TileTextures.LandOne.textureName,
            TileTextures.LandTwo.textureName,
            TileTextures.Camp.textureName,
            TileTextures.TownSign.textureName,
            TileTextures.TownShop.textureName,
            TileTextures.TownInn.textureName,
            TileTextures.AlchemistHouse.textureName,
            TileTextures.Arena.textureName,
            TileTextures.Guild.textureName,
            TileTextures.Prison.textureName,
            TileTextures.Fence.textureName,
            TileTextures.Water.textureName,
            TileTextures.Mountain.textureName,
            TileTextures.Grass.textureName,
            TileTextures.Tree.textureName
        ])
        // put player
        // Load from player's leader unit (yet to implement)
        player = GameUnit(unitTextureName: UnitTextures.Ape.textureName,
                          isAlly: true,
                          preference: UnitPreference.Ape.preference,
                          originalAssignedIndex: -1)
        player.nonActionMove(to: getPositionOnMap(row: campRowCol.x, col: campRowCol.y))
        
        enemies = [GameUnit]()
    }
    
    func generateRandomMap(col: Int, row: Int, textureNames: [String]) {
        initializeMapCreation(col: col, row: row, textureNames: textureNames)
        feedNonVisualMap()
        createVisualMap(textureNames: textureNames)
    }
    
    private func initializeMapCreation(col: Int, row: Int, textureNames: [String]) {
        self.col = col
        self.row = row
        nonVisualMap = [[TileObject]](repeating: [TileObject](repeating: LandOne(x: 0, y: 0), count: col), count: row)
        nonVisualMapOverlay = [[TileObject]](repeating: [TileObject](repeating: LandOne(x: -1, y: -1), count: col), count: row)
        mapFiller = MapFiller(row: row, col: col)

        TextureManager.sharedInstance.removeAllTextures()
        TextureManager.sharedInstance.addTextures(withNames: textureNames)
        TextureManager.sharedInstance.preloadAllTextures()
    }
    
    private func feedNonVisualMap() {
        nonVisualMap = mapFiller.filledMap(with: perlin)
        let mapEdgeLength = edgeLength * max(nonVisualMap.count, nonVisualMap[0].count) / 2
        normalMap = SKNode()
        rotatedMap = SKNode()
        normalMap.position = CGPoint(x: 0, y: 0)
        rotatedMap.position = CGPoint(x: mapEdgeLength*2, y: 0)
        
        addEssentialTiles()
        addLivingCreatures()
        adjustMap()
    }
    
    private func createVisualMap(textureNames: [String]) {
        let normalTileType = assignTileType(tileNames: textureNames)
        let normalVisualMap = visualMap(with: normalTileType)
        normalMap.addChild(normalVisualMap)
        
        let rotatedTileType = assignRotatedTileType(tileNames: textureNames)
        let rotatedVisualMap = visualMap(with: rotatedTileType)
        rotatedMap.addChild(rotatedVisualMap)
        
        let normalVisualMapOverlay = visualMapOverlay()
        normalMap.addChild(normalVisualMapOverlay)
        
        let rotatedVisualMapOverlay = visualMapOverlayRotated()
        rotatedMap.addChild(rotatedVisualMapOverlay)
        
        normalMap.zPosition = -1
        rotatedMap.zPosition = -1
    }
    
    private func addEssentialTiles() {
        // put camp, cannot be on the edge
        let campRow = Int.random(in: 1 ..< row-1)
        let campCol = Int.random(in: 1 ..< col-1)
        campRowCol = Point2D(x: campRow, y: campCol)
        let campPosition = getPositionOnMap(row: campRowCol.x, col: campRowCol.y)
        nonVisualMap[campRowCol.x][campRowCol.y] = idToTile(id: .Camp, x: campPosition.x, y: campPosition.y)
        
        // put portal
        // must be at least 5 manhattan distance from the camp
        var possibleRowColForPortal = [Point2D]()
        for i in 0 ..< row {
            for j in 0 ..< col {
                if CGPoint(x: campRow, y: campCol).manhattanDistance(to: CGPoint(x: i, y: j)) > 5 {
                    possibleRowColForPortal.append(Point2D(x: i, y: j))
                }
            }
        }
        
        portalRowCol = possibleRowColForPortal.randomElement()
        nonVisualMapOverlay[portalRowCol.x][portalRowCol.y] = idToTile(id: TileID.Portal,
                                                     x: CGFloat((portalRowCol.x) * edgeLength+edgeLength/2),
                                                     y: CGFloat((portalRowCol.y) * edgeLength+edgeLength/2))
        let portalPosition = getPositionOnMap(row: portalRowCol.x, col: portalRowCol.y)
        nonVisualMap[portalRowCol.x][portalRowCol.y] = idToTile(id: .Portal, x: portalPosition.x, y: portalPosition.y)
    }
    
    private func addLivingCreatures() {
        // put player
        // Load from player's leader unit (yet to implement)
        player = GameUnit(unitTextureName: UnitTextures.Ape.textureName,
                          isAlly: true,
                          preference: UnitPreference.Ape.preference,
                          originalAssignedIndex: -1)
        player.nonActionMove(to: getPositionOnMap(row: campRowCol.x, col: campRowCol.y))
        
        // put monster
        enemies = [GameUnit]()
        // Load from JSON file
        let levelEnemyData = gameScene?.levelEnemyDataLoader.levelEnemyDatas
        guard let data = levelEnemyData?[gameScene?.currentLevel ?? 0] else {return}

        for i in 0 ..< data.level.count {
            // the first enemy is the leader enemy
            var enemy = GameUnit(unitTextureName: stringToUnitTextureName(imageName: data.level[i].enemy[0].image_name),
                                 isAlly: false,
                                 preference: stringToUnitPreference(imageName: data.level[i].enemy[0].image_name),
                                 originalAssignedIndex: i)
            enemy.nonActionMove(to: randomEnemyGeneratePosition())
            enemies.append(enemy)
            addRangeToEnemy(enemyIndex: i)
            processEnemyHiddenTiles(enemyIndex: i)
        }
    }
    
    private func adjustMap() {
        // the 8 tiles around camp should be non-restricting
        replaceRestrictingTileAroundCamp()
        // there must exist a path between camp and portal
        createPathBetweenCampAndPortal()
        // there must exist paths between each enemy and camp
        for i in 0 ..< enemies.count {
            createPathBetweenEnemyAndCamp(enemyRowCol: getRowColOnMap(objectLocation: enemies[i].position))
        }
    }
    
    func nextTileIsWalkable(movingXY: Point2D, objectLocation: CGPoint) -> Bool {
        let objectRowCol = getRowColOnMap(objectLocation: objectLocation)
        let x = Int(objectRowCol.x) + movingXY.x
        let y = Int(objectRowCol.y) + movingXY.y
        if x < 0 || x >= row || y < 0 || y >= col {return false}
        if nonVisualMap[x][y].isWalkable && !nonVisualMap[x][y].isLiquid && !nonVisualMap[x][y].isTall {
            return true
        }
        return false
    }
    
    func getRowColOnMap(objectLocation: CGPoint) -> Point2D {
        var positionDifference: CGPoint!
        let middle = CGPoint(x: CGFloat(edgeLength) * CGFloat(row+1)/2, y: CGFloat(edgeLength) * CGFloat(col+1)/2)
        if isRotated {
            positionDifference = objectLocation - rotatedMap.position
            //let mapEdgeMidLength = edgeLength * max(row, col) / 2
            //positionDifference = positionDifference + CGPoint(x: -mapEdgeMidLength, y: mapEdgeMidLength)
            positionDifference = positionDifference + CGPoint(x: (CGFloat(edgeLength) * (CGFloat(max(row, col)) + 1)), y: 0)
            positionDifference = positionDifference - middle
            positionDifference = CGPoint(x: positionDifference.y, y: -positionDifference.x)
            positionDifference = positionDifference + middle
        } else {
            positionDifference = objectLocation - normalMap.position
        }
        positionDifference = positionDifference - CGPoint(x: edgeLength/2, y: edgeLength/2)
        return Point2D(x: Int(positionDifference.x / CGFloat(edgeLength)), y: Int(positionDifference.y / CGFloat(edgeLength)))
    }
    
    func thereIsUnitInThisPosition(walkto position: CGPoint) -> Bool {
        guard let player = player else {return false}
        if position == player.position {
            return true
        }
        for enemy in enemies {
            if position == enemy.position {
                return true
            }
        }
        return false
    }
    
    func getPositionOnMap(row: Int, col: Int) -> CGPoint {
        if !isRotated {
            return CGPoint(x: CGFloat(row*edgeLength+edgeLength/2), y: CGFloat(col*edgeLength+edgeLength/2))
        } else {
            let x = self.col - (1+col)
            let y = row
            return CGPoint(x: CGFloat(x*edgeLength+edgeLength/2), y: CGFloat(y*edgeLength+edgeLength/2))
        }
    }
    
    private func addRangeToEnemy(enemyIndex: Int) {
        switch enemies[enemyIndex].getPreference() {
        case Preference.EMPEROR_MELEE.rawValue,
            Preference.GENERAL_MELEE.rawValue,
            Preference.HUNTER_MELEE.rawValue,
            Preference.KNIGHT_MELEE.rawValue,
            Preference.PAWN_MELEE.rawValue,
            Preference.ROOK_MELEE.rawValue:
            let attackingRange = createRange(radius: 3)
            attackingRange.name = "attackingRange"
            let sensingRange = createRange(radius: 7)
            sensingRange.name = "sensingRange"
            enemies[enemyIndex].getModel().addChild(attackingRange)
            enemies[enemyIndex].getModel().addChild(sensingRange)
            break
        case Preference.EMPEROR_RANGE.rawValue,
            Preference.GENERAL_RANGE.rawValue,
            Preference.HUNTER_RANGE.rawValue,
            Preference.KNIGHT_RANGE.rawValue,
            Preference.PAWN_RANGE.rawValue,
            Preference.ROOK_RANGE.rawValue:
            let attackingRange = createRange(radius: 5)
            attackingRange.name = "attackingRange"
            let sensingRange = createRange(radius: 9)
            sensingRange.name = "sensingRange"
            enemies[enemyIndex].getModel().addChild(attackingRange)
            enemies[enemyIndex].getModel().addChild(sensingRange)
            break
        default:
            break
        }
    }
    
    private func createRange(radius: Int) -> SKShapeNode {
        let range = SKShapeNode()
        range.path = UIBezierPath(rect: CGRect(origin: CGPoint(x: -edgeLength*radius/2, y: -edgeLength*radius/2), size: CGSize(width: edgeLength*radius, height: edgeLength*radius))).cgPath
        range.fillColor = UIColor.clear
        range.strokeColor = UIColor.clear
        range.lineWidth = 10
        
        return range
    }
    
    private func randomEnemyGeneratePosition() -> CGPoint {
        // manhattan distance from the camp must be at least 5
        // cannot be on restricting tiles
        
        var validPositions = [CGPoint]()
        for i in 0 ..< nonVisualMap.count {
            for j in 0 ..< nonVisualMap[i].count {
                let tile = nonVisualMap[i][j]
                if !tile.isTall &&
                    !tile.isLiquid &&
                    tile.isWalkable &&
                    !thereIsUnitInThisPosition(walkto: CGPoint(x: tile.x, y: tile.y)) {
                    validPositions.append(CGPoint(x: tile.x, y: tile.y))
                }
            }
        }
        
        var result = validPositions.randomElement()!
        let campPosition = getPositionOnMap(row: campRowCol.x, col: campRowCol.y)
        while result.manhattanDistance(to: campPosition) <= CGFloat(5 * edgeLength) {
            result = validPositions.randomElement()!
        }
        
        return result
    }
    
    private func replaceRestrictingTileAroundCamp() {
        // There cannot be any restricting tile around the camp
        for i in -1 ..< 2 {
            for j in -1 ..< 2 {
                let row = campRowCol.x + i
                let col = campRowCol.y + j
                if i == 0 && j == 0 {
                    continue
                }
                if row < 0 || col < 0 || row >= self.row || col >= self.col {
                    continue
                }
                let position = getPositionOnMap(row: row, col: col)
                nonVisualMap[row][col] = idToTile(id: .Grass, x: position.x, y: position.y)
            }
        }
    }
    
    private func createPathBetweenEnemyAndCamp(enemyRowCol: Point2D) {
        let dfs: DFS<TileObject> = DFS(matrix: nonVisualMap)
        while !dfs.DFS(x: enemyRowCol.x, y: enemyRowCol.y, targetX: campRowCol.x, targetY: campRowCol.y) {
            guard let index = dfs.invalidTilePositions.indices.randomElement() else {return}
            let position = dfs.invalidTilePositions[index]
            let rowCol = getRowColOnMap(objectLocation: CGPoint(x: position.first, y: position.second))
            nonVisualMap[Int(rowCol.x)][Int(rowCol.y)] = idToTile(id: .Grass, x: CGFloat(position.first), y: CGFloat(position.second))
            dfs.invalidTilePositions.remove(at: index)
            dfs.matrix = nonVisualMap
            dfs.resetVis()
        }
    }
    
    private func createPathBetweenCampAndPortal() {
        // search if there is a path between camp and portal
        let dfs: DFS<TileObject> = DFS(matrix: nonVisualMap)
        while !dfs.DFS(x: campRowCol.x, y: campRowCol.y, targetX: portalRowCol.x, targetY: portalRowCol.y) {
            guard let index = dfs.invalidTilePositions.indices.randomElement() else {return}
            let position = dfs.invalidTilePositions[index]
            let rowCol = getRowColOnMap(objectLocation: CGPoint(x: position.first, y: position.second))
            nonVisualMap[Int(rowCol.x)][Int(rowCol.y)] = idToTile(id: .Grass, x: CGFloat(position.first), y: CGFloat(position.second))
            dfs.invalidTilePositions.remove(at: index)
            dfs.matrix = nonVisualMap
            dfs.resetVis()
         }
    }
    
    func monstersWalk() {
        monsterWalkManager.monstersWalk()
    }
    
    func setTriggerBattleEnemyIndex(index: Int) {
        gameScene?.viewController.controller.setTriggerBattleEnemyIndex(to: index)
    }
    
    func inBattleNowIsTrue() {
        gameScene?.viewController.controller.setInBattleNow(to: true)
    }
    
    func checkIfPlayerInAttackRange() {
        monsterWalkManager.checkIfPlayerInAttackRange()
    }
    
    func segueToBattleScene() {
        guard let gameScene = self.gameScene else {return}
        guard let viewController = gameScene.viewController else {return}
        viewController.controller.segueToBattleScene()
    }
    
    func removeEnemyByIndex(_ index: Int) {
        enemies[index].getModel().removeFromParent()
        enemies.remove(at: index)
    }
    
    func isPlayerOnPortal() -> Bool {
        return player.position == getPositionOnMap(row: portalRowCol.x, col: portalRowCol.y)
    }
    
    func teleportPlayerToCamp() {
        player.nonActionMove(to: getPositionOnMap(row: campRowCol.x, col: campRowCol.y))
        gameScene?.cameraNode.run(SKAction.move(to: player.position, duration: TimeController.regularCameraMovement))
    }
    
    func processPlayerHiddenTiles() {
        let rowCol = getRowColOnMap(objectLocation: player.position)
        if nonVisualMap[rowCol.x][rowCol.y].canHideObject {
            player.getModel().colorBlendFactor = 0.5
            player.getModel().color = .black
            player.isBeingHidden = true
        } else {
            player.getModel().colorBlendFactor = 0
            player.isBeingHidden = false
        }
    }
    
    // hide the enemy if walked into a hidden tile
    func processEnemyHiddenTiles(enemyIndex: Int) {
        let rowCol = getRowColOnMap(objectLocation: enemies[enemyIndex].position)
        if nonVisualMap[rowCol.x][rowCol.y].canHideObject {
            enemies[enemyIndex].getModel().alpha = 0
            enemies[enemyIndex].isBeingHidden = true
        } else {
            enemies[enemyIndex].getModel().alpha = 1
            enemies[enemyIndex].isBeingHidden = false
        }
    }
    
    func isPlayerOnEnterableTile() -> Bool {
        let rowCol = getRowColOnMap(objectLocation: player.position)
        return nonVisualMap[rowCol.x][rowCol.y].isEnterable
    }
    
    func isPlayerOnCampTile() -> Bool {
        let rowCol = getRowColOnMap(objectLocation: player.position)
        return campRowCol == rowCol
    }
}
