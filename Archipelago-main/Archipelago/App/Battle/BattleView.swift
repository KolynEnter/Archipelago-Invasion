//
//  BattleView.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/11/23.
//

import Foundation
import UIKit

struct BattleView: BattleViewProtocol {
    private weak var controller: BattleController!
    
    init(controller: BattleController) {
        self.controller = controller
    }
    
    func settingIsPressed(_ sender: Any) {
        if !controller.settingIsOpened() {
            controller.viewController.settingButton.setImage(UIImage(named: "ExitSetting"), for: .normal)
            controller.viewController.escapeButton.isHidden = false
            controller.viewController.turnSignButton.isHidden = true
            controller.setSettingBackgroundHidden(to: false)
            controller.setSettingIsOpen(to: true)
        } else {
            controller.viewController.settingButton.setImage(UIImage(named: "Cog"), for: .normal)
            controller.viewController.escapeButton.isHidden = true
            controller.viewController.turnSignButton.isHidden = false
            controller.setSettingBackgroundHidden(to: true)
            controller.setSettingIsOpen(to: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accounting cell", for: indexPath) as! AccountingCell
        cell.label1.text = controller.getAccountingMaterials()[indexPath.row].name
        if controller.getAccountingMaterials()[indexPath.row].number == -1 {
            cell.label2.text = "" // the text is "You gained:"
        } else {
            cell.label2.text = String(controller.getAccountingMaterials()[indexPath.row].number)
        }
        cell.selectionStyle = .none
        changeToAppFont(forLabel: cell.label1)
        changeToAppFont(forLabel: cell.label2)
        
        return cell
    }
}
