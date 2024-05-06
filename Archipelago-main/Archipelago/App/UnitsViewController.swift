//
//  UnitsViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/14/23.
//

import UIKit
import SpriteKit
import GameplayKit

class UnitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var unitsScene: UnitsScene!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var allyUnits = [AllyUnit]()
    var skills = [Skill]()
    
    let allyUnitLoader = AllyUnitsLoader()
    
    @IBOutlet weak var bigUnitImageView: UIImageView!
    @IBOutlet weak var subview: UIView!
    
    @IBOutlet weak var leaderButton: UIButton!
    @IBOutlet weak var teamButton: UIButton!
    @IBOutlet weak var emptyButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var soulRequiredLabel: UILabel!
    @IBOutlet weak var passiveSkillIconImageView: UIImageView!
    @IBOutlet weak var passiveSkillTextView: UITextView!
    @IBOutlet weak var skillSelectTable: UITableView!
    @IBOutlet weak var possessedSoulLabel: UILabel!
    @IBOutlet weak var skillSelectLabel: UILabel!
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var youHaveLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var inUnitSelection: Bool = false
    var currentUnitIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'MainScene.sks'
            if let scene = SKScene(fileNamed: "UnitsScene") {
                unitsScene = scene as? UnitsScene
                // Set the scale mode to scale to fit the window
                unitsScene.scaleMode = .aspectFill
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(unitsScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        allyUnits = allyUnitLoader.models
        
        bigUnitImageView.isHidden = true
        subview.isHidden = true
        skillSelectTable.isHidden = true
        levelLabel.isHidden = true
        
        skillSelectTable.delegate = self
        skillSelectTable.dataSource = self
        skillSelectTable.backgroundColor = .clear
        skillSelectTable.showsHorizontalScrollIndicator = false
        skillSelectTable.showsVerticalScrollIndicator = false
        skillSelectTable.backgroundColor = UIColor.black
        skillSelectTable.layer.cornerRadius = 9
        
        if currentDeviceOrientation == DeviceOrientation.portriat {
            subview.layer.position = CGPoint(x: 196.5, y: 565.0)
        } else {
            subview.layer.position = CGPoint(x: 600, y: 200)
        }
        emptyButton.isHidden = true
        
        changeToAppFont(forButton: leaderButton)
        changeToAppFont(forButton: teamButton)
        changeToAppFont(forLabel: levelLabel)
        changeToAppFont(forLabel: soulRequiredLabel)
        changeToAppFont(forLabel: possessedSoulLabel)
        changeToAppFont(forTextView: passiveSkillTextView)
        changeToAppFont(forLabel: skillSelectLabel)
        changeToAppFont(forLabel: upgradeLabel)
        changeToAppFont(forLabel: youHaveLabel)
        changeToAppFont(forButton: okButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if currentDeviceOrientation == DeviceOrientation.portriat {
            subview.layer.position = CGPoint(x: 196.5, y: 565.0)
        } else {
            subview.layer.position = CGPoint(x: 600, y: 200)
        }
    }
    
    @IBAction func goBackToGameViewController(_ sender: Any) {
        if inUnitSelection {
            self.collectionView.isHidden = false
            bigUnitImageView.isHidden = true
            subview.isHidden = true
            leaderButton.isHidden = false
            teamButton.isHidden = false
            inUnitSelection = false
            skillSelectTable.isHidden = true
            levelLabel.isHidden = true
            return
        }
        
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
    
    
    @IBAction func upgradeButtonPressed(_ sender: Any) {
        let allyLoader = AllyUnitsLoader()
        let inventoryLoader = PlayerInventoryLoader()
        guard let id = allyLoader.models[currentUnitIndex].uniqueID else { return }
        //inventoryLoader.spendSoul(allyLoader.useSoulOnLevelUp(uniqueID: id, totalSoul: Int(inventoryLoader.getNumberOfSoul())))
        inventoryLoader.spendSoul(allyLoader.useSoulOnLevelUp(uniqueID: id, totalSoul: 99999999)) // testing
        possessedSoulLabel.text = String(inventoryLoader.getNumberOfSoul())
        soulRequiredLabel.text = "\(String(XPCalculator().xpForLevel(Int(allyLoader.models[currentUnitIndex].level)))) souls"
        levelLabel.text = "Level: \(String(allyLoader.models[currentUnitIndex].level))"
        allyLoader.changeSkillSet(uniqueID: id, newSkillSet: [SquirrelSpell()])
    }
    
    // https://stackoverflow.com/questions/38025112/how-do-i-set-collection-views-cell-size-via-the-auto-layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        var widthRemainingForCellContent = collectionView.bounds.width
        if currentDeviceOrientation == DeviceOrientation.landscape {
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return CGSize.zero}
            guard let firstWindow = firstScene.windows.first else {return CGSize.zero}
            widthRemainingForCellContent = firstWindow.bounds.height-20 // minus 20 due to constraints
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
        }
        let cellWidth = widthRemainingForCellContent / cellsAcross
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    // enlarging units view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.isHidden = true
        bigUnitImageView.isHidden = false
        subview.isHidden = false
        leaderButton.isHidden = true
        teamButton.isHidden = true
        skillSelectTable.isHidden = false
        levelLabel.isHidden = false
        possessedSoulLabel.text = String(PlayerInventoryLoader().getNumberOfSoul())
        
        var unpicedImage = UIImage(named: "Unpiced-Item")
        unpicedImage = unpicedImage?.scaleImage(toSize: CGSize(width: 64, height: 64), framePosition: CGPoint(x: 0, y: 0))
        passiveSkillIconImageView.image = unpicedImage
        passiveSkillIconImageView.layer.cornerRadius = 18
        
        let unit = allyUnits[indexPath.item]
        currentUnitIndex = indexPath.item
        soulRequiredLabel.text = "\(String(XPCalculator().xpForLevel(Int(unit.level)))) souls"
        levelLabel.text = "Level: \(String(AllyUnitsLoader().models[currentUnitIndex].level))"
        var unitImage = UIImage(named: stringToUnitTextureName(imageName: unit.imageName!))
        unitImage = unitImage?.scaleImage(toSize: CGSize(width: 2048, height: 2048), framePosition: CGPoint(x: 0, y: 0))
        bigUnitImageView.image = unitImage
        bigUnitImageView.layer.cornerRadius = 18
        passiveSkillTextView.layer.cornerRadius = 9
        
        skills = [Skill]()
        if allyUnits[indexPath.item].skill0 != "nil" {
            skills.append(stringToSkill(name: allyUnits[indexPath.item].skill0 ?? "nil"))
        }
        if allyUnits[indexPath.item].skill1 != "nil" {
            skills.append(stringToSkill(name: allyUnits[indexPath.item].skill1 ?? "nil"))
        }
        if allyUnits[indexPath.item].skill2 != "nil" {
            skills.append(stringToSkill(name: allyUnits[indexPath.item].skill2 ?? "nil"))
        }
        if allyUnits[indexPath.item].skill3 != "nil" {
            skills.append(stringToSkill(name: allyUnits[indexPath.item].skill3 ?? "nil"))
        }
        skillSelectTable.reloadData()
        inUnitSelection = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allyUnits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnitsViewCell", for: indexPath) as! UnitsViewCell
        let unit = allyUnits[indexPath.item]
        var unitImage = UIImage(named: stringToUnitTextureName(imageName: unit.imageName!))
        let realUnit = stringToUnit(imageName: unit.imageName!)
        let framePosition = realUnit.framePosition
        unitImage = unitImage?.scaleImage(toSize: CGSize(width: 2048, height: 2048), framePosition: framePosition)
        
        cell.unitsImageView.image = unitImage
        cell.unitsImageView.layer.magnificationFilter = .nearest
        cell.unitsNameLabel.text = unit.name
        cell.unitsNameLabel.textColor = .white
        cell.layer.cornerRadius = 18
        cell.contentView.isUserInteractionEnabled = false
        changeToAppFont(forLabel: cell.unitsNameLabel)
        
        return cell
    }
}

// https://stackoverflow.com/questions/31966885/resize-uiimage-to-200x200pt-px
extension UIImage {
    func scaleImage(toSize newSize: CGSize, framePosition: CGPoint) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: framePosition.x*3.5, y: framePosition.y*3.5, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .none
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}

extension UnitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Skill Select Cell", for: indexPath) as! SkillSelectCell
        cell.skillNameLabel.text = skills[indexPath.row].name
        cell.checkMark = UIImageView()
        cell.selectionStyle = .none
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 9
        changeToAppFont(forLabel: cell.skillNameLabel)
        
        return cell
    }
}
