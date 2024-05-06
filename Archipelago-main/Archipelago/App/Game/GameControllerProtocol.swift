//
//  GameControllerProtocol.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/10/23.
//

import Foundation
import UIKit

protocol GameControllerProtocol {
    func loadNewMap()
    func segueToBattleScene()
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func viewWillAppear(_ animated: Bool)
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    func viewDidDisappear(_ animated: Bool)
    func moveUpPressed(_ sender: Any)
    func moveDownPressed(_ sender: Any)
    func moveLeftPressed(_ sender: Any)
    func moveRightPressed(_ sender: Any)
    func move(dx: Int, dy: Int)
    func pressGameMenu(_ sender: Any)
    func processIfPlayerIsOnEnterable()
    func enterHouseButtonPressed(_ sender: Any)
    func checkIfPlayerIsOnPortal() -> Bool
    func checkIfBattleStart(playerPosition: CGPoint) -> Bool
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}
