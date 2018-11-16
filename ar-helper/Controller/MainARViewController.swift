//
//  MainARViewController.swift
//  ar-helper
//
//  Created by Igor Chernyshov on 13/11/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MainARViewController: UIViewController, ARSCNViewDelegate {
  
  @IBOutlet var sceneView: ARSCNView!
  
  var currentContainer: SCNNode?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Create a gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onScreenTap(gesture:)))
    self.view.addGestureRecognizer(tapGesture)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Remove currentContainer if contains anything
    currentContainer = nil
    
    // Set the view's delegate
    sceneView.delegate = self
    
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = false
    
    // Create a new scene
    let scene = SCNScene(named: "art.scnassets/main.scn")!
    
    // Set the scene to the view
    sceneView.scene = scene
    
    // Create a session configuration
    let configuration = ARImageTrackingConfiguration()
    
    guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
    configuration.trackingImages = trackedImages
    
    // Run the view's session
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARImageAnchor else { return }
    
    // Container
    guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
    currentContainer?.removeFromParentNode()
    currentContainer = container
    node.addChildNode(currentContainer!)
    
    // Animations
    currentContainer!.runAction(SCNAction.fadeIn(duration: 0.5))
  }
  
  @objc func onScreenTap(gesture: UITapGestureRecognizer) {
    guard currentContainer != nil else { return }
    
    let transitionAnimation = SCNAction.sequence([
      SCNAction.moveBy(x: -0.095, y: 0.4, z: 0, duration: 0.5),
      SCNAction.customAction(duration: 0, action: { (node, float) in
        self.performSegue(withIdentifier: "toExamineViewController", sender: nil)
      })
    ])
  
    currentContainer!.runAction(transitionAnimation)
  }
}
