//
//  ContentView.swift
//  ARTest
//
//  Created by user on 2023/05/01.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @ObservedObject var arViewModel: ARViewModel = ARViewModel()
    
    var body: some View {
        VStack {
            ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
                .onTapGesture(coordinateSpace: .global) { location in
                    arViewModel.raycastFunc(location: location)
                }
            
            
            Button {
                arViewModel.switchCamera()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath.camera")
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
}


struct ARViewContainer: UIViewRepresentable {
    
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
    
    var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        return arViewModel.arView
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
