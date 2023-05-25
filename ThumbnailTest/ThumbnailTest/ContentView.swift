//
//  ContentView.swift
//  ThumbnailTest
//
//  Created by user on 2023/05/13.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    let arViewContainer = ARViewContainer()
    @State var thumbnail: UIImage?
    @State var tempSnapShot: UIImage?
    @State var showDetailView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if thumbnail != nil {
                    Image(uiImage: thumbnail!)
                        .resizable()
                        .scaledToFit()
                }
                
                arViewContainer.edgesIgnoringSafeArea(.all)
                
                Button("Take photo") {
                    arViewContainer.arView.snapshot(saveToHDR: false) { image in
                        tempSnapShot = image
                    }
                    showDetailView = true
                }
                
                NavigationLink("", isActive:  $showDetailView) {
                    DetailView(thumbnail: $thumbnail,tempSnapShot: tempSnapShot)
                }
            }
        }
    }
}

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var thumbnail: UIImage?
    var tempSnapShot: UIImage?
    var body: some View {
        VStack {
            if tempSnapShot != nil {
                Image(uiImage: tempSnapShot!)
                    .resizable()
                    .scaledToFit()
            }
            
            Button("Exit") {
                UIImageWriteToSavedPhotosAlbum(tempSnapShot!, nil, nil, nil)
                thumbnail = tempSnapShot
                dismiss()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .zero)
    
    func makeUIView(context: Context) -> ARView {
        
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
