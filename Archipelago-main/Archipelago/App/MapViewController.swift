//
//  MapViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/14/23.
//

import UIKit
import SpriteKit
import GameplayKit

// https://stackoverflow.com/questions/42003296/is-it-possible-to-create-a-scroll-view-with-an-animated-page-control-in-swift

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var mapScene: MapScene!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var mapTitleLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    private let mapNames: [String] = ["Forest", "Desert", "Windy land", "Volcano", "Ice land", "Fog kindom", "Town"]
    private let mapDescription: [String] = [
        "A beginner friendly map.",
        "The second map, it is a bit harder.",
        "The third map, harder than the second one.",
        "The fourth map, not bad you are here.",
        "The fifth map, let's see how far you can still go.",
        "The sixth map, you are really good at this.",
        "The safe place. (Warning: you will exit from the map)"
    ]
    
    // Variables asociated to collection view:
    fileprivate var currentPage: Int = 0
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    fileprivate var colors: [UIColor] = [UIColor.green, UIColor.brown, UIColor.cyan, UIColor.red, UIColor.white, UIColor.gray, UIColor.orange]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'MapScene.sks'
            if let scene = SKScene(fileNamed: "MapScene") {
                mapScene = scene as? MapScene
                // Set the scale mode to scale to fit the window
                mapScene.scaleMode = .aspectFill
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(mapScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
        self.addCollectionView()
        self.currentPage = 0
        mapTitleLabel.text = mapNames[currentPage]
        textview.text = mapDescription[currentPage]
        if currentDeviceOrientation == DeviceOrientation.portriat {
            subview.layer.position = CGPoint(x: 196.5, y: 565.0)
        } else {
            subview.layer.position = CGPoint(x: 635, y: 250)
        }
        //textview.layer.cornerRadius = 9
        
        changeToAppFont(forLabel: mapTitleLabel)
        changeToAppFont(forTextView: textview)
        changeToAppFont(forButton: enterButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if currentDeviceOrientation == DeviceOrientation.portriat {
            subview.layer.position = CGPoint(x: 196.5, y: 565.0)
        } else {
            subview.layer.position = CGPoint(x: 635, y: 250)
        }
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

    func addCollectionView() {
        // This is where the magic is done. With the flow layout the views are set to make costum movements. See https://github.com/ink-spot/UPCarouselFlowLayout for more info
        let layout = UPCarouselFlowLayout()
        // This is used for setting the cell size (size of each view in this case)
        // Here I'm writting 400 points of height and the 73.33% of the height view frame in points.
        layout.itemSize = CGSize(width: collectionView.bounds.width/2, height: 225)
        // Setting the scroll direction
        layout.scrollDirection = .horizontal

        // Collection view initialization, the collectionView must be
        // initialized with a layout object.
        //self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.frame = .zero
        collectionView.collectionViewLayout = layout
        // This line if for able programmatic constrains.
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        // CollectionView delegates and dataSource:
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        // Registering the class for the collection view cells
        self.collectionView?.register(CardCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        // Spacing between cells:
        let spacingLayout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        spacingLayout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 20)

        self.collectionView?.backgroundColor = UIColor.clear
    }

        // MARK: - Card Collection Delegate & DataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CardCell
        cell.customView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        mapTitleLabel.text = mapNames[currentPage]
        textview.text = mapDescription[currentPage]
    }
    
    
    @IBAction func enterMap(_ sender: Any) {
        if mapNames[currentPage] == "Town" {
            loadTownMap()
        } else if mapNames[currentPage] == "Forest" {
            leaveTownAndLoadMap(mapName: "Forest")
        }
    }
    
    // play animation
    // dismiss the current game map
    // load town map to the new game map
    // dismiss the map view controller
    func loadTownMap() {
        loadGameViewControllerMap(isToTown: true)
    }
    
    func leaveTownAndLoadMap(mapName: String) {
        loadGameViewControllerMap(isToTown: false)
    }
    
    func loadGameViewControllerMap(isToTown: Bool) {
        let head = HeadStyleTransition(picture: "Dummy head")
        head.addAllImages(view: view)
        head.slidingImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 - TimeController.regularCameraMovement, execute: {
            self.newMapView(isToTown: isToTown)
        })
    }
    
    private func newMapView(isToTown: Bool) {
        guard let viewControllers = self.navigationController?.viewControllers,
              let index = viewControllers.firstIndex(where: {$0 is GameViewController}) else { return }
        let gameViewController = viewControllers[index] as? GameViewController
        gameViewController?.performSegue(withIdentifier: "GameToGame", sender: nil)
        // remove the old game map
        gameViewController?.dismiss(animated: false)
        gameViewController?.view.removeFromSuperview()
        gameViewController?.removeFromParent()
        self.navigationController?.viewControllers.remove(at: index)
        
        // the game map is now a town map
        guard let newController = self.navigationController?.viewControllers[1] as? GameViewController else {return}
        newController.setController()
        newController.controller.setCurrentLevel(to: 1)
        if isToTown {newController.controller.goToTown()} else {newController.controller.leaveTown()}
        
        // remove self
        guard let viewControllers = self.navigationController?.viewControllers,
        let index = viewControllers.firstIndex(of: self) else { return }
        self.navigationController?.viewControllers.remove(at: index)
    }
}

class CardCell: UICollectionViewCell {
    let customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.customView)
        
        self.customView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.customView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.customView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        self.customView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
} // End of CardCell
