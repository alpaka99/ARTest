//
//  ARViewContainer.swift
//  ImageToARTest
//
//  Created by user on 2023/05/08.
//

import Foundation
import RealityKit
import SwiftUI
import UIKit
import CoreImage

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        ARVariables.arView = ARView(frame: .zero)
        
        return ARVariables.arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
}

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
            if let anchorEntity = entity.anchor, anchorEntity.name == "ImageAnchor" {
                anchorEntity.removeFromParent()
                print("Removed anchor with name: " + anchorEntity.name)
            }
        }
    }
    
//    func raycastFunc(location: CGPoint, image: UIImage?) {
//    func raycastFunc(location: CGPoint, url: UIImage?) {
//        guard let result = ARVariables.arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first
//        else { return }
//        
//        guard let inputImage = image else { return }
//        
//        let worldPos = simd_make_float3(result.worldTransform.columns.3)
//          
//        let cubeEntity = ModelEntity(mesh: .generateBox(size: 0.5, cornerRadius: 0), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
//        cubeEntity.generateCollisionShapes(recursive: true) // create collisionshape
//          
//          let raycastAnchor = AnchorEntity(world: worldPos)
//        raycastAnchor.name = "CubeAnchor"
//          
////          raycastAnchor.addChild(sphereEntity)
//          raycastAnchor.addChild(cubeEntity)
//        ARVariables.arView.scene.anchors.append(raycastAnchor)
//        
//    
//        
//    
//        ARVariables.arView.installGestures([.translation, .rotation, .scale], for: cubeEntity)
//      }
    
    
    func showARImage(location: CGPoint, url: URL?) {
        print("Entered")

        guard let fileUrl = url else { return }
        
        
        let anchor = AnchorEntity(world: [0, 0, -1])
        
        let ball: MeshResource = .generateSphere(radius: 0.25)
        
        var material = UnlitMaterial()
        material.color = try! .init(tint: .white, texture: .init(.load(contentsOf: fileUrl)))
        
        let ballEntity = ModelEntity(mesh: ball, materials: [material])
        
        anchor.addChild(ballEntity)
        self.scene.anchors.append(anchor)
        
    }
    
    func makeTransparent(image: UIImage) -> UIImage? {
        guard let rawImage = image.cgImage else {
            print("Out 1")
            return nil
            
        }
        
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
//        UIGraphicsBeginImageContext(image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        
        if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
            let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0.0, y: image.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage
        }
        print("Out 2")
        return nil
    }
}
