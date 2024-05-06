//
//  BattleViewProtocol.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/11/23.
//

import Foundation
import UIKit

protocol BattleViewProtocol {
    func settingIsPressed(_ sender: Any)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}
