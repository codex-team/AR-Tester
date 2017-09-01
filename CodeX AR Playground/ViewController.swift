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
        
        sceneView.debugOptions  = [.showLightExtents, ARSCNDebugOptions.showFeaturePoints]
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func addIpad(position: SCNVector3, anchor: ARPlaneAnchor) {
        
        let sceneIpad = SCNScene(named: "art.scnassets/iPad.scn")
        
        let planeNode = SCNNode(geometry: sceneIpad?.rootNode.childNode(withName: "iPad", recursively: false)?.geometry)
        
        // Create the geometry and its materials
        _ = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        planeNode.scale = SCNVector3Make(0.001, 0.001, 0.001);
//        planeNode.eulerAngles.y = sceneView.pointOfView!.eulerAngles.y
//        planeNode.eulerAngles.x = sceneView.pointOfView!.eulerAngles.x
//        planeNode.eulerAngles.z = sceneView.pointOfView!.eulerAngles.z
        
        planeNode.position = SCNVector3Make(position.x, position.y, position.z)
//        planeNode.pivot = SCNMatrix4MakeRotation(Float.pi / 2, planeNode.eulerAngles.x, planeNode.eulerAngles.y, planeNode.eulerAngles.z)
        
//        sceneView.scene.rootNode.addChildNode(planeNode)
        
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
        
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        addIpad(position: hitPosition, anchor: planeAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

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
    
    // When a plane is detected, make a planeNode for it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        debugPrint(planeAnchor)
        
//        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//
//        let lavaImage = UIImage(named: "lava-0.png")
//        let lavaMaterial = SCNMaterial()
//        lavaMaterial.diffuse.contents = lavaImage
//        lavaMaterial.isDoubleSided = true
//
//        plane.materials = [lavaMaterial]
//
//        let planeNode = SCNNode(geometry: plane)
//        planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//
//        let box = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
//        box.firstMaterial?.diffuse.contents = UIColor.blue
//        box.firstMaterial?.transparency = 1
//        box.firstMaterial?.isDoubleSided = true
//
//        let boxNode = SCNNode(geometry: box)
//        boxNode.position = SCNVector3(0,0.25,0)
//
        let sceneIpad = SCNScene(named: "art.scnassets/r8_gt_obj/r8_gt_obj.scn")
        let ipadNode = SCNNode(geometry: sceneIpad?.rootNode.childNode(withName: "r8_gt_obj", recursively: false)?.geometry)
//        let ipadNode = SCNNode(geometry: sceneIpad?.rootNode.geometry)
        //ipadNode.scale = SCNVector3Make(0.001, 0.001, 0.001)
        ipadNode.position = SCNVector3(0,0,0)
//        ipadNode.transform = SCNMatrix4MakeRotation(-Float.pi, 0, 1, 0)
        
//        sceneView.scene.rootNode.addChildNode(boxNode)
//        node.addChildNode(planeNode)
        node.addChildNode(ipadNode)
//        node.addChildNode(boxNode)
        
//        let planeNode = createPlaneNode(anchor: planeAnchor)
//         ARKit owns the node corresponding to the anchor, so make the plane a child node.
//        node.addChildNode(planeNode)
    }

}
