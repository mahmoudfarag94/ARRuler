//
//  ViewController.swift
//  ARRuler
//
//  Created by mahmoud on 11/26/18.
//  Copyright © 2018 mahmoud. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var dotsArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotsArray.count >= 2{
            for point in dotsArray{
                point.removeFromParentNode()
            }
            dotsArray = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView){
            let touchResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let touchResult = touchResults.first{
                addNewPoint(at:touchResult)
                
            }
        }
    }
    
    //func to add new point in real world .
    func addNewPoint(at hitResult:ARHitTestResult){
        let dotSpare = SCNSphere(radius: 0.002)
        let spareMatrial = SCNMaterial()
        spareMatrial.diffuse.contents = UIColor.red
        dotSpare.materials = [spareMatrial]
        
        let spareNode = SCNNode(geometry: dotSpare)
        spareNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x
            , hitResult.worldTransform.columns.3.y
            , hitResult.worldTransform.columns.3.z
        )
        sceneView.scene.rootNode.addChildNode(spareNode)
        dotsArray.append(spareNode)
        if dotsArray.count >= 2{
            calculateDistance()
        }
    }
    
    
    // func to calculate distance between two point .
    func calculateDistance()  {
        let st = dotsArray[0]
        let end = dotsArray[1]
        
        let a = st.position.x - end.position.x
        let b = st.position.y - end.position.y
        let c = st.position.z - end.position.z
        let distance = sqrt(pow(a, 2) + pow(b, 2)+pow(c, 2))
        print(abs(distance))
    }
    
    

}
