//
//  ARModel.swift
//  ARTest
//
//  Created by user on 2023/05/01.
//

import Foundation
import RealityKit
import ARKit

struct ARModel {
    private(set) var arView: ARView
    
    init() {
        arView = ARView(frame: .zero)
        arView.enableObjectRemoval()
    }
    
    func switchCamera() {
        guard var newConfig = arView.session.configuration else {
            fatalError("Unexpectedly failed to get the configuration.")
        }
        
        switch newConfig {
        case is ARWorldTrackingConfiguration:
            newConfig = ARFaceTrackingConfiguration()
        case is ARFaceTrackingConfiguration:
            newConfig = ARWorldTrackingConfiguration()
        default:
            // If something is messed up
            newConfig = ARWorldTrackingConfiguration()
        }
        
        arView.session.run(newConfig)
    }

    mutating func raycastFunc(location: CGPoint) {
//        guard let query = arView.makeRaycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal)
//          else { return }
          
        guard let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first
        else { return }
        
        let worldPos = simd_make_float3(result.worldTransform.columns.3)
          
//          let sphereEntity = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        let cubeEntity = ModelEntity(mesh: .generateBox(size: 0.5, cornerRadius: 0), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
          
          let raycastAnchor = AnchorEntity(world: worldPos)
        raycastAnchor.name = "CubeAnchor"
          
//          raycastAnchor.addChild(sphereEntity)
          raycastAnchor.addChild(cubeEntity)
          arView.scene.anchors.append(raycastAnchor)
        
        // create collisionshape
//        sphereEntity.generateCollisionShapes(recursive: true)
        cubeEntity.generateCollisionShapes(recursive: true)
        
//        arView.installGestures([.translation, .rotation, .scale], for: sphereEntity)
        arView.installGestures([.translation, .rotation, .scale], for: cubeEntity)
      }
}


// Create extension of ARView to enable longPressGesture to delete AR object
extension ARView {
    // Create enableObjectRemoval() function to add longPressGesture recognizer
    func enableObjectRemoval() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    // Create selector to handleLongPress
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        if let entity = self.entity(at: location) {
            // 1. entity 에 anchor 가 있는지 없는지 if let, 그 이후 결과로 나온 anchorEntity의 이름이 "CubeAnchor" 와 같다면
            if let anchorEntity = entity.anchor, anchorEntity.name == "CubeAnchor" {
                anchorEntity.removeFromParent()
                print("Removed anchor with name: " + anchorEntity.name)
            }
        }
    }
}
