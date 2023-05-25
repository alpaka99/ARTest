//
//  ContentView.swift
//  ARNumberTest
//
//  Created by user on 2023/05/03.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var count = Count()
    
    var body: some View {
        ZStack {
            VStack {
                ARViewContainer(count: count)
                VStack {
                    Spacer()
                    CustomButtonBarView(count: count)
                }
            }
        }
        .ignoresSafeArea(.all)
//        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

//struct ARViewContainer: UIViewRepresentable {
//    
//    func makeUIView(context: Context) -> ARView {
//        
//        let arView = ARView(frame: .zero)
//        
//        // Load the "Box" scene from the "Experience" Reality File
//        let boxAnchor = try! Experience.loadBox()
//        
//        // Add the box anchor to the scene
//        arView.scene.anchors.append(boxAnchor)
//        
//        return arView
//        
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
//    
//}

