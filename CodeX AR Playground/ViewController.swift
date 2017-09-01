//
//  ViewController.swift
//  CodeX AR Playground
//
//  Created by Peter Savchenko on 28/08/2017.
//  Copyright © 2017 Peter Savchenko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions  = [.showConstraints, .showLightExtents, ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func addNewShip(position: SCNVector3) {
        
        let sceneIpad = SCNScene(named: "art.scnassets/iPad.scn")
        
        let planeNode = SCNNode(geometry: sceneIpad?.rootNode.childNode(withName: "iPad", recursively: false)?.geometry)
        
        planeNode.scale = SCNVector3Make(0.001, 0.001, 0.001);
        planeNode.eulerAngles.y = sceneView.pointOfView!.eulerAngles.y
        planeNode.eulerAngles.x = sceneView.pointOfView!.eulerAngles.x
        planeNode.eulerAngles.z = sceneView.pointOfView!.eulerAngles.z
        planeNode.position = SCNVector3Make(position.x, position.y, position.z)
        
        sceneView.scene.rootNode.addChildNode(planeNode)
        
//        let planeNode = SCNNode(geometry: textNode)
//        planeNode.scale = SCNVector3Make(0.05, 0.05, 0.05);
//        planeNode.eulerAngles.y = sceneView.pointOfView!.eulerAngles.y
//        planeNode.eulerAngles.x = sceneView.pointOfView!.eulerAngles.x
//        planeNode.eulerAngles.z = sceneView.pointOfView!.eulerAngles.z
        
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    func floatBetween(_ first: Float,  and second: Float) -> Float { // random float between upper and lower bound (inclusive)
        return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        debugPrint("touchesBegan")
        
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        addNewShip(position: hitPosition)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
