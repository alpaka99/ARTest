//
//  ARViewContainer.swift
//  ARLoadImageTest
//
//  Created by user on 2023/05/08.
//

import SwiftUI
import RealityKit
import ARKit
import CoreImage


struct ARViewContainer: UIViewRepresentable {
    @State private var image: Image?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
    func loadImage() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
    }
}
