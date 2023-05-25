//
//  ARViewContainer.swift
//  AR facetracking test
//
//  Created by user on 2023/05/06.
//

import SwiftUI
import ARKit
import RealityKit
import UIKit

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        ARVariables.arView = ARView(frame: .zero)
        
        let faceAnchor = try! HalfMask.load장면()
//        let faceAnchor2 = try! Experience.loadBox()
        
        let faceTrackingConfig = ARFaceTrackingConfiguration()
        
        
        faceTrackingConfig.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        print(faceTrackingConfig.maximumNumberOfTrackedFaces)
        faceTrackingConfig.isLightEstimationEnabled = true
        
//        ARVariables.arView.session.run(faceTrackingConfig)
        
        ARVariables.arView.session.run(faceTrackingConfig, options: [.resetTracking, .removeExistingAnchors])
        
//        ARVariables.arView.scene.anchors.append(faceAnchor)
        
        return ARVariables.arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        let faceAnchor1 = try! HalfMask.load장면()
//        let faceAnchor2 = try! Experience.loadBox()
//        let faceAnchor3 = try! HalfMask.load장면()
        ARVariables.arView.scene.anchors.append(faceAnchor1)
//        ARVariables.arView.scene.anchors.append(faceAnchor2)
//        ARVariables.arView.scene.anchors.append(faceAnchor3)
    }
    
    
    func takeSnapShot() {
        DispatchQueue.global(qos: .userInitiated).async {
            ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                let compressedImage = UIImage(data: (image?.pngData())!)
                
                UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            }
        }
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator: NSObject, ARSessionDelegate {
//
//        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//            print(anchors.count)
//            guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
//
//            let anchor1 = AnchorEntity(anchor: faceAnchor)
//            let anchor2 = AnchorEntity(anchor: faceAnchor)
//
//            let faceModel1 = try! HalfMask.load장면()
//            let faceModel2 = try! Experience.loadBox()
//
//            anchor1.addChild(faceModel1)
//            anchor2.addChild(faceModel2)
//
//            ARVariables.arView.scene.anchors.append(anchor1)
//            ARVariables.arView.scene.anchors.append(anchor2)
//
//        }
//    }
}


extension ARView: ARSessionDelegate {
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("Entered")
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        
        let anchor1 = AnchorEntity(anchor: faceAnchor)
        let anchor2 = AnchorEntity(anchor: faceAnchor)
        
        let faceModel1 = try! HalfMask.load장면()
        let faceModel2 = try! Experience.loadBox()
        
        anchor1.addChild(faceModel1)
        anchor2.addChild(faceModel2)
        
        ARVariables.arView.scene.anchors.append(anchor1)
        ARVariables.arView.scene.anchors.append(anchor2)
        
    }
}





//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
