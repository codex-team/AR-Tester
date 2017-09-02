//
//  SceneViewController.swift
//  CodeX AR Playground
//
//  Created by Peter Savchenko on 02/09/2017.
//  Copyright © 2017 Peter Savchenko. All rights reserved.
//
import UIKit
import SceneKit
import WebKit

class SceneViewController: UIViewController {

    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    var webView: WKWebView!
    
    var shadowView : UIView!
    
    let iPadFrameSize = CGRect(x: 0.0, y: 0.0, width: 768.0, height: 1024.0)
    
    var device: SCNNode!
    
    var testingSiteURL = URL(string: "https://ifmo.su")
    
    @IBOutlet weak var scnView: SCNView!
    
    var spawnTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        spawnShape()
        setupShadowView()
    
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupShadowView(){
        
        shadowView.frame = iPadFrameSize
        
        // Move out the screen
        shadowView.frame.origin.x = 1000.0
    
        
        view.addSubview(shadowView)
        
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
        
        geometry.sources(for: .texcoord)
        
        device = SCNNode(geometry: geometry)
        
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
        
        device.position = SCNVector3(x: x, y: y, z: z)
        
        let color = UIColor.blue
        geometry.materials.first?.diffuse.contents = color
        
        
        scnScene.rootNode.addChildNode(device)
        
        print("Start loading page")
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        shadowView = webView
        
        let myURL = testingSiteURL
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        

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

extension SceneViewController: SCNSceneRendererDelegate {
    
    
}

extension SceneViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("Webview did finish loading")
        debugPrint(webView)
        
        let image = screenShot()
        
        print(image)
        
//        device.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        device.geometry?.firstMaterial?.diffuse.contents = image
        
    }
    
    func screenShot( ) -> UIImage {
        
        debugPrint(self.shadowView.frame)
        UIGraphicsBeginImageContextWithOptions(self.shadowView.frame.size, true, 1.0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        self.shadowView.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
}



