//
//  AttackButton.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/26/22.
//

import SpriteKit

var repealSet: [Skill] = [Repeal(), Repeal(), Repeal(), Repeal()]

func panelShownAlready(userSkills: [Skill], user: Unit, target: Unit) -> Bool {
    if userSkills.count == 0 {return false}
    if user.floatingPanelIsShown {return true}
    user.floatingPanelIsShown = true
    user.characterBase.isHidden = false
    target.characterBase.isHidden = false
    
    return false
}

func skillRows(numberOfSkillRow: Int, userSkills: [Skill], user: Unit, target: Unit, cameraXScale: CGFloat) -> SKSpriteNode {
    var panel = assignFloatingPanel(position: CGPoint(x: -300*cameraXScale, y: 0))
    if currentDeviceOrientation == DeviceOrientation.landscape {
        panel = assignFloatingPanel(position: CGPoint(x: -200*cameraXScale, y: 0))
    }
    panel.setScale(cameraXScale/UIScale().skillPanelDivisionRatio)
    if currentDeviceOrientation == DeviceOrientation.portriat {
        panel.setScale(panel.xScale*1.5)
    }
    panel.position = CGPoint(x: panel.position.x + target.position.x, y: panel.position.y + target.position.y)
    
    let base = assignBase(rows: numberOfSkillRow)
    var floatingButtonYaxis: [Int] = [];
    switch numberOfSkillRow {
    case 1:
        floatingButtonYaxis = FloatingButtonYaxis.one
        break
    case 2:
        floatingButtonYaxis = FloatingButtonYaxis.two
        break
    case 3:
        floatingButtonYaxis = FloatingButtonYaxis.three
        break
    case 4:
        floatingButtonYaxis = FloatingButtonYaxis.four
        break
    default:
        break
    }
    let message = assignMessage(user: user, target: target, yOfBaseTop: floatingButtonYaxis.first ?? 0)
    
    var counter = 0
    for yPosition in floatingButtonYaxis {
        let button = assignSkillButton(yPosition: yPosition, skill: userSkills[counter], user: user, target: target, basePos: base.position, counter: counter)
        base.addChild(button)
        if userSkills[counter].currentCooldown == 0 {
            let skillText = assignSkillTextLabel(skill: userSkills[counter], isInCoolDown: false, textPosition: CGPoint(x: base.position.x, y: base.position.y + button.position.y))
            panel.addChild(skillText)
        }
        counter += 1
    }
    
    panel.addChild(base)
    panel.addChild(message)
    return panel
}

func useRepealSet(user: Unit, target: Unit, cameraXScale: CGFloat) -> SKSpriteNode {
    return skillRows(numberOfSkillRow: 4, userSkills: repealSet, user: user, target: target, cameraXScale: cameraXScale)
}

private func assignFloatingPanel(position: CGPoint) -> SKSpriteNode {
    let panel = SKSpriteNode()
    panel.zPosition = zPositions.floatingPanel
    panel.position = position
    
    return panel
}

private func assignBase(rows: Int) -> SKSpriteNode {
    let base = SKSpriteNode(imageNamed: "SkillPanelBase\(rows)x")
    base.position = CGPoint(x: 0, y: 0)
    base.alpha = 0.7
    base.zPosition = zPositions.floatingPanel
    
    return base
}

private func assignMessage(user: Unit, target: Unit, yOfBaseTop: Int) -> SKSpriteNode {
    let panel = SKSpriteNode()
    panel.position = CGPoint(x: 0 , y: yOfBaseTop)
    panel.anchorPoint = CGPoint(x: 0, y: 0)
    
    //let userLabel = SKLabelNode(fontNamed: AppFont.font + "-Bold")
    let userLabel = SKLabelNode(fontNamed: AppFont.font)
    userLabel.text = user.name ?? "Unknown"
    userLabel.fontSize = FontSize.message
    userLabel.position = CGPoint(x: -120, y: 220)
    userLabel.horizontalAlignmentMode = .right
    userLabel.fontColor = user.fontColor
    
    let icon = SKSpriteNode(imageNamed: "Attack")
    icon.setScale(0.3)
    icon.texture?.filteringMode = .nearest
    icon.position = CGPoint(x: 0, y: 240)
    
    //let targetLabel = SKLabelNode(fontNamed: AppFont.font + "-Bold")
    let targetLabel = SKLabelNode(fontNamed: AppFont.font)
    targetLabel.text = target.name ?? "Unknown"
    targetLabel.fontSize = FontSize.message
    targetLabel.position = CGPoint(x: 120, y: 220)
    targetLabel.horizontalAlignmentMode = .left
    targetLabel.fontColor = target.fontColor
    
    let charUsed: Int = 2 * max((user.name?.count ?? 0), (target.name?.count ?? 0))
    let rectBase = SKSpriteNode(color: SKColor.black, size: CGSizeMake((FontSize.characterName+2)*CGFloat(charUsed) + 300, 140))
    rectBase.alpha = 0.7
    rectBase.position = CGPoint(x: 0, y: 240)
    
    panel.addChild(rectBase)
    panel.addChild(userLabel)
    panel.addChild(icon)
    panel.addChild(targetLabel)
    
    return panel
}

private func assignSkillButton(yPosition: Int, skill: Skill, user: Unit, target: Unit, basePos: CGPoint, counter: Int) -> SKSpriteNode {
    let button = FloatingButton(yAxis: yPosition)
    button.name = String(counter)
    if skill.currentCooldown != 0 {
        let skillText = assignSkillTextLabel(skill: skill, isInCoolDown: true, textPosition: CGPoint(x: 0, y: 0))
        button.addChild(skillText)
    }
    if isSkillCannotBeUsed(skill: skill, user: user, target: target) {
        let cropNode = assignSkillCropNode(percent: 0)
        button.addChild(cropNode)
        let skillText = assignSkillTextLabel(skill: skill, isInCoolDown: true, textPosition: CGPoint(x: 0, y: 0))
        button.addChild(skillText)
    } else if skill.originalCooldown != 0 {
        let cropNode = assignSkillCropNode(percent: 1-CGFloat(skill.currentCooldown)/CGFloat(skill.originalCooldown))
        button.addChild(cropNode)
    }
    
    return button
}

private func isSkillCannotBeUsed(skill: Skill, user: Unit, target: Unit) -> Bool {
    var isInCoolDown: Bool = false
    isInCoolDown = (skill.skillType == .MULT_ALLY && target.isAlly != user.isAlly) ||
        (skill.skillType == .MULT_ENEMY && target.isAlly == user.isAlly) ||
        (skill.skillType == .SOLO_ALLY && target.isAlly != user.isAlly) ||
        (skill.skillType == .SOLO_ENEMY && target.isAlly == user.isAlly)
    return isInCoolDown
}

private func assignSkillTextLabel(skill: Skill, isInCoolDown: Bool, textPosition: CGPoint) -> SKLabelNode {
    let skillText = SKLabelNode(fontNamed: AppFont.font)
    skillText.text = skill.name
    skillText.fontSize = FontSize.button
    skillText.verticalAlignmentMode = .center
    skillText.zPosition = zPositions.floatingPanel+10
    skillText.position = textPosition
    if isInCoolDown {
        skillText.fontColor = UIColor.red
        skillText.fontSize = FontSize.atkButton-10
    }
    
    return skillText
}

// the skill cannot be used is the percent is not 1
private func assignSkillCropNode(percent: CGFloat) -> SKCropNode {
    let mask = SKSpriteNode(imageNamed: "SkillPanelButton")
    let cropNode = SKCropNode()
    cropNode.maskNode = mask
    let cooldownProgress = SKSpriteNode(color: UIColor.red, size: mask.size)
    cooldownProgress.position = CGPoint(x: -mask.size.width*percent, y: 0)
    let filledCropNode = SKCropNode()
    let filled = SKSpriteNode(color: UIColor.red, size: CGSize(width: mask.size.width, height: mask.size.height))
    filled.position = CGPoint(x: -mask.size.width*percent, y: 0)
    filledCropNode.maskNode = filled
    filledCropNode.addChild(cooldownProgress)
    cropNode.addChild(filledCropNode)
    
    return cropNode
}
