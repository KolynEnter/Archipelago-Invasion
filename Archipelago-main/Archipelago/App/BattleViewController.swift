//
//  BattleViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/14/23.
//

import UIKit
import SpriteKit
import GameplayKit

class BattleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var turnSignButton: UIButton!
    @IBOutlet var escapeButton: UIButton!
    @IBOutlet weak var accountingTitle: UILabel!
    @IBOutlet weak var accountingConfirm: UIButton!
    @IBOutlet weak var materialTable: UITableView!
    
    var controller: BattleController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        if controller == nil {setController()}
        controller.warmBattleView()
    }
    
    func setController() {
        controller = BattleController(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        controller.viewWillAppear(animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        controller.viewDidDisappear(animated)
        super.viewDidDisappear(animated)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        controller.viewWillTransition(to: size, with: coordinator)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func goToAccounting(battleResult: BattleResult) {
        controller.goToAccounting(battleResult: battleResult)
    }
    
    @IBAction func settingIsPressed(_ sender: Any) {
        controller.settingIsPressed(sender)
    }
    
    @IBAction func turnSignIsPressed(_ sender: Any) {
        controller.turnSignIsPressed(sender)
    }
    
    @IBAction func accountingConfirmPressed(_ sender: Any) {
        controller.accountingConfirmPressed(sender)
    }
    
    @IBAction func escapeButtonPressed(_ sender: Any) {
        controller.escapeButtonPressed(sender)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.getAccountingMaterials().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return controller.tableView(tableView, cellForRowAt: indexPath)
    }
    
    deinit {
           print("\n THE SCENE \(type(of:self)) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
