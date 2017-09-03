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
import WebKit

class CameraController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var overlayLabel: UILabel!
    
    var webView: WKWebView!
    var shadowView : UIView!
    
    let iPadFrameSize = CGRect(x: 0.0, y: 0.0, width: 768.0, height: 1024.0)
    
    var lastPlaneNode: SCNNode?
    var lastAnchor: UUID?
    var iPadUUID: UUID?
    var currentImage: UIImage?
    var iPadScene: SCNScene?
    var iPad: SCNNode?
    
    var enteredURL: String = ""
    
    var currentPlane:SCNNode? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("User enters URL: ")
        print(enteredURL)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.debugOptions  = [.showLightExtents]
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
        overlay.isUserInteractionEnabled = false
        
        // load scenes
        iPadScene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTap))
        sceneView.addGestureRecognizer(tap)
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        shadowView = webView
        
        setupShadowView()
        loadImage()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    func loadImage()
    {
        if enteredURL == "" || enteredURL == nil {
            return
        }
        
        let myURL = URL(string: enteredURL)
        
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func didTap( _ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: sceneView)
        debugPrint("location")
        debugPrint(location);
        
        guard let _ = currentPlane else {
            guard let newPlaneData = anyPlaneFrom(location: location) else { return }
            
            debugPrint("New plane data")
            debugPrint(newPlaneData)

            lastPlaneNode?.removeFromParentNode()
            addIpad(node: newPlaneData.0, position: newPlaneData.1)
            return
        }
        
    }
    
    private func anyPlaneFrom(location:CGPoint) -> (SCNNode, SCNVector3)? {
        let results = sceneView.hitTest(location,
                                        types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        
        guard results.count > 0,
            let anchor = results[0].anchor as? ARPlaneAnchor,
            let node = sceneView.node(for: anchor) else { return nil }
        
        iPadUUID = anchor.identifier
        return (node, SCNVector3(x: anchor.center.x, y: anchor.center.y, z: anchor.center.z))
    }
    
    func addIpad(node: SCNNode, position: SCNVector3) {
        
        if iPad != nil {
            node.addChildNode(iPad!)
        } else {
            iPad = (iPadScene?.rootNode.childNode(withName: "iPad", recursively: true))!
        }
        
        self.overlay?.removeFromSuperview()
        
        iPad?.geometry?.sources(for: .texcoord)
        if currentImage != nil {
            iPad?.geometry?.material(named: "Mat_3")?.diffuse.contents = currentImage
        }
        
        iPad?.position = position
        node.addChildNode(iPad!)
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
    
    func setupShadowView(){
        
        shadowView.frame = iPadFrameSize
        
        // Move out the screen
        shadowView.frame.origin.x = 1000.0
        
        
        view.addSubview(shadowView)
        
    }
    
    // When a plane is detected, make a planeNode for it
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        lastAnchor = planeAnchor.identifier
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))

        DispatchQueue.main.async {
            self.overlayLabel?.text = "Tap to place device"
        }
        
        plane.materials.first?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1, alpha: 0.35)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        lastPlaneNode?.removeFromParentNode()
        
        lastPlaneNode = planeNode
        node.addChildNode(planeNode)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        if planeAnchor.identifier == lastAnchor {
            return
        }
        
        if planeAnchor.identifier == iPadUUID {
            return
        }
        
        lastAnchor = planeAnchor.identifier
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        plane.materials.first?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1, alpha: 0.35)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        lastPlaneNode?.removeFromParentNode()
        
        lastPlaneNode = planeNode
        node.addChildNode(planeNode)
        
    }
}

extension CameraController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("Webview did finish loading")
        
        let image = screenShot()
        
        currentImage = image
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
