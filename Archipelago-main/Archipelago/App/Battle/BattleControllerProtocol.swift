//
//  BattleControllerProtocol.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/11/23.
//

import Foundation
import UIKit

protocol BattleControllerProtocol {
    func viewWillAppear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    func goToAccounting(battleResult: BattleResult)
    func turnSignIsPressed(_ sender: Any)
    func accountingConfirmPressed(_ sender: Any)
    func escapeButtonPressed(_ sender: Any)
}
