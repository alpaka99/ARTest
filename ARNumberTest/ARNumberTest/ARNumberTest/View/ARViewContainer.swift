//
//  ARViewContainer.swift
//  ARNumberTest
//
//  Created by user on 2023/05/03.
//


import Foundation
import RealityKit
import SwiftUI
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var count: Count
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("This device does not support personSegmentationWithDepth")
        }
        
        let config = ARWorldTrackingConfiguration()
        config.frameSemantics.insert(.personSegmentationWithDepth)
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        updateCounter(uiView: uiView)
    }
    
    private func updateCounter(uiView: ARView) {
        print(count.num)
        print("\n\n\n\n")
        uiView.scene.anchors.removeAll() // 우선 anchor 를 다 지워서 현재 화면의 숫자를 지움
        
        let anchor = AnchorEntity()
        let text = MeshResource.generateText(
            "\(abs(count.num))",
            extrusionDepth: 0.08,
            font: .systemFont(ofSize: 0.5, weight: .bold)
        )
        
        
        let color: UIColor
        
        switch count.num {
        case let x where x < 0:
            color = .red
        case let x where x > 0:
            color = .green
        default:
            color = .white
        }
        
        
        let shader = SimpleMaterial(color: color, roughness: 4, isMetallic: false)
        let textEntity = ModelEntity(mesh: text, materials: [shader])
        
        textEntity.position.z -= 1.5
        
        
        textEntity.setParent(anchor) // entity 를 앵커에
        uiView.scene.addAnchor(anchor) // 앵커를 scene 에
    }
}
