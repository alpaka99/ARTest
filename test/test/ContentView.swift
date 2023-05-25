//
//  ContentView.swift
//  test
//
//  Created by user on 2023/05/09.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("This device does not support personSegmentationWithDepth")
        }
        
        let config = ARWorldTrackingConfiguration()
        config.frameSemantics.insert(.personSegmentationWithDepth)
        arView.session.run(config)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
