//
//  ContentView.swift
//  ImageToARTest
//
//  Created by user on 2023/05/08.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var showImagePicker = false
    @State private var imageURL: URL?
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
                .onTapGesture(coordinateSpace: .global) { location in
//                    ARVariables.arView.showARImage(location: location, url: imageURL)
                    ARVariables.arView.showARImage(location: location, url: imageURL)
                }
            
            Button("Pick image") {
                showImagePicker = true
            }
        }
        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(imageURL: $imageURL)
            ImagePicker(image: $inputImage)
        }
    }
}

