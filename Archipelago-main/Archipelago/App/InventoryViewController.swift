//
//  InventoryViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/14/23.
//

import UIKit
import SpriteKit
import GameplayKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var inventoryScene: InventoryScene!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    
    let playerInventoryLoader = PlayerInventoryLoader()
    
    var items = [InventoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'InventoryScene.sks'
            if let scene = SKScene(fileNamed: "InventoryScene") {
                inventoryScene = scene as? InventoryScene
                // Set the scale mode to scale to fit the window
                inventoryScene.scaleMode = .aspectFill
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(inventoryScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 44
        view.backgroundColor = .clear
        
        items = playerInventoryLoader.models
        changeToAppFont(forButton: itemsButton)
        changeToAppFont(forButton: rewardButton)
        changeToAppFont(forButton: notesButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    }
    
    @IBAction func goBackToGameViewController(_ sender: Any) {
        guard let viewControllers = navigationController?.viewControllers,
        let index = viewControllers.firstIndex(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InventoryViewCell
        cell.label1.text = items[indexPath.row].name
        cell.label2.text = String(items[indexPath.row].number)
        cell.selectionStyle = .none
        changeToAppFont(forLabel: cell.label1)
        changeToAppFont(forLabel: cell.label2)
        
        return cell
    }
    
    @IBAction func itemsButtonPressed(_ sender: Any) {
        items = playerInventoryLoader.models
        tableView.reloadData()
    }
    
    
    @IBAction func awardButtonPressed(_ sender: Any) {
        items = []
        tableView.reloadData()
    }
    
    
    @IBAction func notesButtonPressed(_ sender: Any) {
        items = []
        tableView.reloadData()
    }
}
