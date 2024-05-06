//
//  BattleScene.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/23/22.
//

import SpriteKit
import GameplayKit

class BattleScene: TouchScene {
    var characterBar: SKSpriteNode!
    var characterFrame: SKSpriteNode!
    let mapCreator = BattleMapCreator()
    var settingBackground: SKSpriteNode!
    let cropNode = SKCropNode()
    var statsBar: SKSpriteNode!
    let characterNameLabel = SKLabelNode(fontNamed: AppFont.font)
    let describeLabel = SKLabelNode(fontNamed: AppFont.font)
    let rightEdgeNode = SKLabelNode(text: "")
    let upEdgeNode = SKLabelNode(text: "")
    
    let buffIconLabel = SKLabelNode(text: "")
    var battleManager: BattleManager!
    
    weak var viewController: BattleViewController?
    private var rotator: BattleSceneRotator!
    private var toucher: BattleSceneToucher!
    private var hpBar = ProgressBar()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "BattleScene"
        warmScene()
        createStartingLayout()
        createStatsBar()
        createCharacterFrame()
        createSettingBackground()
        createCharacterNameLabel()
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinch(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    func warmScene() {
        self.name = "BattleScene"
        cameraNode = camera ?? SKCameraNode()
        cameraNode.setScale(6)
        
        if currentDeviceOrientation == DeviceOrientation.landscape {
            cameraNode.setScale(PincherMate.mapLandscapeMin.val)
        } else if currentDeviceOrientation == DeviceOrientation.portriat {
            cameraNode.setScale(PincherMate.mapPortraitMin.val)
        }
        
        mapCreator.generateFileBasedMap()
        addChild(mapCreator.battleMap)
        
        rotator = BattleSceneRotator(battleScene: self)
        toucher = BattleSceneToucher(battleScene: self)
        
        rightEdgeNode.zPosition = 0
        rightEdgeNode.position = CGPoint(x: frameMidX, y: 0)
        cameraNode.addChild(rightEdgeNode)
        
        upEdgeNode.zPosition = 0
        upEdgeNode.position = CGPoint(x: 0, y: frameMidY)
        cameraNode.addChild(upEdgeNode)
        
        battleManager = BattleManager(battleScene: self)
        cameraNode.position = mapCreator.cameraCenter()
    }
    
    // need to receive enemy data
    private func createStartingLayout() {
        // define a player region: 5 x 5
        // find a center
        let playerRegionCenterRow = Int.random(in: 2 ..< mapCreator.row - 2)
        let playerRegionCenterCol = Int.random(in: 2 ..< mapCreator.col - 2)
        let playerRegionCenter = Point2D(x: playerRegionCenterRow, y: playerRegionCenterCol)
        let yellowSquare = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: mapCreator.edgeLength * 5, height: mapCreator.edgeLength * 5))
        yellowSquare.alpha = 0.5
        yellowSquare.position = CGPoint(x: playerRegionCenter.x * mapCreator.edgeLength,
                                            y: playerRegionCenter.y * mapCreator.edgeLength)
        yellowSquare.position = yellowSquare.position + CGPoint(x: mapCreator.edgeLength/2, y: mapCreator.edgeLength/2)
        addChild(yellowSquare)
        
        // put all player units to playe region
        var playerRegion = [Point2D]()
        for i in playerRegionCenterRow-2 ..< playerRegionCenterRow + 3 {
            for j in playerRegionCenterCol-2 ..< playerRegionCenterCol + 3 {
                playerRegion.append(Point2D(x: i, y: j))
            }
        }
        
        var apePosition = CGPoint(x: playerRegionCenter.x * mapCreator.edgeLength,
                               y: playerRegionCenter.y * mapCreator.edgeLength)
        apePosition = apePosition + CGPoint(x: mapCreator.edgeLength/2, y: mapCreator.edgeLength/2)
        
        var woodNymphPosition = CGPoint(x: (playerRegionCenter.x + 1) * mapCreator.edgeLength,
                                     y: playerRegionCenter.y * mapCreator.edgeLength)
        woodNymphPosition = woodNymphPosition + CGPoint(x: mapCreator.edgeLength/2, y: mapCreator.edgeLength/2)
        
        var deerPosition = CGPoint(x: (playerRegionCenter.x - 1) * mapCreator.edgeLength,
                                y: playerRegionCenter.y * mapCreator.edgeLength)
        deerPosition = deerPosition + CGPoint(x: mapCreator.edgeLength/2, y: mapCreator.edgeLength/2)
        
        var wolfPosition = CGPoint(x: playerRegionCenter.x * mapCreator.edgeLength,
                                y: (playerRegionCenter.y + 1) * mapCreator.edgeLength)
        wolfPosition = wolfPosition + CGPoint(x: mapCreator.edgeLength/2, y: mapCreator.edgeLength/2)
        
        let allyLoader = AllyUnitsLoader()
        battleManager.generatePlayerUnit(position: apePosition, allyUnit: allyLoader.models[0])
        battleManager.generatePlayerUnit(position: woodNymphPosition, allyUnit: allyLoader.models[1])
        battleManager.generatePlayerUnit(position: deerPosition, allyUnit: allyLoader.models[2])
        battleManager.generatePlayerUnit(position: wolfPosition, allyUnit: allyLoader.models[3])
        
        // First time generation
        /*
        battleManager.generatePlayerUnit(position: apePosition, id: UnitID.Ape, skills: [])
        battleManager.generatePlayerUnit(position: woodNymphPosition, id: UnitID.WoodNymph, skills: [])
        battleManager.generatePlayerUnit(position: deerPosition, id: UnitID.Deer, skills: [])
        battleManager.generatePlayerUnit(position: wolfPosition, id: UnitID.Wolf, skills: [])
         */
        
        // put enemies
        guard let enemies = viewController?.controller.getEnemyInLeveEnemyData(withIndex: viewController!.controller.getTriggerBattleEnemyIndex()) else {return}
        guard let currencies = viewController?.controller.getLootInLevelEnemyData(withIndex: viewController!.controller.getTriggerBattleEnemyIndex()) else {return}
        var possibleEnemyRowCols = [Point2D]()
        for i in 0 ..< mapCreator.row {
            for j in 0 ..< mapCreator.col {
                if CGPoint(x: playerRegionCenter.x, y: playerRegionCenter.y).manhattanDistance(to: CGPoint(x: i, y: j)) > 5 {
                    possibleEnemyRowCols.append(Point2D(x: i, y: j))
                }
            }
        }
        
        for i in 0 ..< enemies.count {
            for _ in 0 ..< enemies[i].number {
                let randomIndex = Int.random(in: 0 ..< possibleEnemyRowCols.count)
                let rowCol = possibleEnemyRowCols[randomIndex]
                let position = CGPoint(x: rowCol.x * mapCreator.edgeLength + mapCreator.edgeLength/2,
                                       y: rowCol.y * mapCreator.edgeLength + mapCreator.edgeLength/2)
                var additionalMaterials = enemies[i].materials
                additionalMaterials.append(MaterialDrop(name: "Cash", chances: ["\(currencies[0]):100"]))
                additionalMaterials.append(MaterialDrop(name: "Soul", chances: ["\(currencies[1]):100"]))
                battleManager.generateEnemy(enemyPosition: position,
                                              enemyID: stringToUnitID(imageName: enemies[i].image_name) ?? 0,
                                              magnification: enemies[i].magnification,
                                              additionalMaterials: additionalMaterials,
                                              skills: enemies[i].skills)
                possibleEnemyRowCols.remove(at: randomIndex)
            }
        }
        battleManager.initializeBuffManager()
    }
    
    private func createStatsBar() {
        statsBar = SKSpriteNode(color: UIColor(white: 0, alpha: 0), size: CGSize(width: 0, height: 0))
        statsBar.zPosition = zPositions.menuBar-1
        statsBar.position = CGPoint(x: 600, y: 0)
        statsBar.setScale(UIScale().scale)
        if UIDevice.current.userInterfaceIdiom == .pad {
            statsBar.position = CGPoint(x: 750, y: 0)
        }
        
        let stats = SKLabelNode(text: "")
        stats.constraints = [SKConstraint.distance(SKRange(lowerLimit: CGFloat(-200), upperLimit: CGFloat(-200)), to: rightEdgeNode),
                             SKConstraint.distance(SKRange(lowerLimit: CGFloat(0), upperLimit: CGFloat(100)), to: upEdgeNode)]
        stats.addChild(statsBar)
        cameraNode.addChild(stats)
        
        hpBar.name = "HP Bar"
        hpBar.buildProgressBar()
        hpBar.position = CGPoint(x: -840, y: 0)
        hpBar.zPosition = zPositions.characterFrame-5
        statsBar.addChild(hpBar)
        statsBar.addChild(buffIconLabel)
    }
    
    private func createCharacterFrame() {
        characterFrame = SKSpriteNode(imageNamed: "CharacterFrameDefault")
        characterFrame.name = "characterFrame"
        characterFrame.zPosition = zPositions.characterFrame
        characterFrame.position = CGPoint(x: -200, y: 0)
        characterFrame.setScale(0.8)
        statsBar.addChild(characterFrame)
        
        cropNode.position = CGPoint(x: 0, y: 0)
        cropNode.zPosition = zPositions.characterFrame+2
        cropNode.maskNode = SKSpriteNode(imageNamed: "CharacterMask")
        characterFrame.addChild(cropNode)
        
        let baseNode = SKSpriteNode(imageNamed: "CharacterMask")
        baseNode.position = CGPoint(x: 0, y: 0)
        characterFrame.addChild(baseNode)
        baseNode.zPosition = zPositions.characterFrame-1
    }
    
    func updateCharacterNode(unit: Unit) {
        cropNode.removeAllChildren()
        unit.characterBase.isHidden = true
        let characterNode = SKSpriteNode(imageNamed: unit.getImageName())
        characterNode.texture?.filteringMode = .nearest
        characterNode.scale(to: CGSize(width: 400, height: 400))
        characterNode.zPosition = zPositions.characterFrame+1
        characterNode.position = unit.framePosition
        characterNameLabel.text = unit.name
        let myFont: UIFont = UIFont(name: AppFont.font, size: FontSize.message) ?? .systemFont(ofSize: 40)
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.foregroundColor : unit.fontColor,
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font : myFont]
        as [NSAttributedString.Key : Any]
        characterNameLabel.attributedText = NSMutableAttributedString(string: unit.name ?? "", attributes: strokeTextAttributes)
        characterNameLabel.fontColor = unit.fontColor
        cropNode.addChild(characterNode)
        battleManager.buffManager.showBuffIcon(battleIndex: unit.battleIndex)
        
        hpBar.updateProgressBar(hpCurrent: unit.hpCurrent, hpMax: unit.hpMax)
    }
    
    private func createSettingBackground() {
        settingBackground = SKSpriteNode(color: UIColor(white: 0, alpha: 0.7), size: CGSize(width: size.width, height: size.height))
        settingBackground.zPosition = zPositions.setting
        cameraNode.addChild(settingBackground)
        settingBackground.isHidden = true
    }
    
    private func createCharacterNameLabel() {
        characterNameLabel.position = CGPoint(x: -290, y: 64)
        characterNameLabel.fontSize = FontSize.characterName
        characterNameLabel.horizontalAlignmentMode = .right
        statsBar.addChild(characterNameLabel)
    }
    
    func nodesTapped(at point: CGPoint) {
        toucher.nodesTapped(at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        toucher.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toucher.touchesEnded(touches, with: event)
    }
    
    func rotated() {
        rotator.rotated()
    }
    
    func getSelectedItem() -> SKSpriteNode? {
        return toucher.getSelectedItem()
    }
    
    func setSelectedItem(to item: SKSpriteNode) {
        toucher.setSelectedItem(to: item)
    }
    
    func setSelectedItemToNull() {
        toucher.setSelectedItemToNull()
    }
    
    func getCurrentTurn() -> Int {
        return toucher.getCurrentTurn()
    }
    
    func setCurrentTurn(to turn: Int) {
        toucher.setCurrentTurn(to: turn)
    }
    
    func updateHPBar(to unit: Unit) {
        hpBar.updateProgressBar(hpCurrent: unit.hpCurrent, hpMax: unit.hpMax)
        updateCharacterNode(unit: unit)
    }
    
    func setControlledUnitBattleIndex(to index: Int) {
        toucher.setControlledUnitBattleIndex(to: index)
    }
    
    //pinch around touch point
    @objc func pinch(_ recognizer:UIPinchGestureRecognizer) {
        guard let viewController = self.viewController else {return}
        if viewController.controller.settingIsOpened() {return}
        Pincher().pinch(recognizer, scene: self)
    }
    
    deinit {
           print("\n THE SCENE \(type(of:self)) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
