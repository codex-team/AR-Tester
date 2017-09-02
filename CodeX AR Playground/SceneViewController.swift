//
//  SceneViewController.swift
//  CodeX AR Playground
//
//  Created by Peter Savchenko on 02/09/2017.
//  Copyright © 2017 Peter Savchenko. All rights reserved.
//
import UIKit
import SceneKit

class SceneViewController: UIViewController, SCNSceneRendererDelegate {

    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    @IBOutlet weak var scnView: SCNView!
    
    var spawnTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        
        spawnShape()
    
    
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView (){
        
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        
        scnView.delegate = self
        
        scnView.isPlaying = true
        
        
    }
    
    func setupScene(){
        scnScene = SCNScene()
        scnView.scene = scnScene
        
        scnScene.background.contents = UIColor.darkGray
    }
    
    func setupCamera(){
        cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        scnScene.rootNode.addChildNode(cameraNode)
        
    }
    
    func spawnShape () {
        let geometry: SCNGeometry = SCNBox(width: 2.5, height: 0.3, length: 3.5 , chamferRadius: 0.0)
        
        let geometryNode = SCNNode(geometry: geometry)
        
//        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
       
//        let force = SCNVector3(x: 0, y: 0 , z: 0)
//        // 3
//        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
//        // 4
//        geometryNode.physicsBody?.applyForce(force,
//                                             at: position, asImpulse: true)
//
        
        let x = Float(arc4random()) / Float(UINT32_MAX)
        let y = Float(arc4random()) / Float(UINT32_MAX)
        let z = Float(arc4random()) / Float(UINT32_MAX)
        
        geometryNode.position = SCNVector3(x: x, y: y, z: z)
        
        let color = UIColor.blue
        geometry.materials.first?.diffuse.contents = color
        
        
        scnScene.rootNode.addChildNode(geometryNode)
        

    }
    
    func cleanScene() {
        // 1
        for node in scnScene.rootNode.childNodes {
            // 2
            if node.presentation.position.y < -2 {
                // 3
                node.removeFromParentNode()
            }
        }
    }
    

    
}

