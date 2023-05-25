//
//  ViewController.swift
//  ARCoreLocationTest
//
//  Created by user on 2023/05/07.
//

import UIKit
import SpriteKit
import ARKit
import GLKit

class ViewController: UIViewController, ARSKViewDelegate {
    let endLocation = CLLocation(latitude: 36.014340, longitude: 129.325421)
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // define coordinates system based on gravity and compass points
        configuration.worldAlignment = .gravityAndHeading
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(text: "🙂")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // calculate degrees from current location to end location
    static func bearingBetween(startLocation: CLLocation, endLocation: CLLocation) -> Float {
        
        var azimuth: Float = 0
        
        let lat1 = GLKMathDegreesToRadians(Float(startLocation.coordinate.latitude))
        let lon1 = GLKMathDegreesToRadians(Float(startLocation.coordinate.longitude))
        
        let lat2 = GLKMathDegreesToRadians(Float(endLocation.coordinate.latitude))
        let lon2 = GLKMathDegreesToRadians(Float(endLocation.coordinate.longitude))
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        
        let radiansBearing = atan2(y, x)
        
        azimuth = GLKMathRadiansToDegrees(Float(radiansBearing))
        
        if (azimuth < 0) { azimuth += 360 }
        return azimuth
    }
    
    // add waypoint marker pointing towards destination at a distance of 5m away from camera
    func getTransformGiven(currentLocation: CLLocation) -> matrix_float4x4 {
        let bearing = ViewController.bearingBetween(startLocation: currentLocation, endLocation: endLocation)

        let distance = 5
        let originTransform = matrix_identity_float4x4

        // Create a transform with a translation of 5 meter away
        let translationMatrix = MatrixHelper.getTranslationZMatrix(tz: Float(distance * -1))

        //Rotation matrix theta degrees
        let rotationMatrix = MatrixHelper.rotateMatrixAroundY(degrees: bearing * -1)
        )
//        let rotationMatrix = MatrixHelper.getRotationYMatrix(angle: Float(Double(bearing) * 180 / Double.pi))

//        var transformMatrix = (rotationMatrix, translationMatrix)
        var transformMatrix = simd_mul(translationMatrix, rotationMatrix)
        return simd_mul(originTransform, transformMatrix)
    }
    
}
