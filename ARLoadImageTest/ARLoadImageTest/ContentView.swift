//
//  ContentView.swift
//  ARLoadImageTest
//
//  Created by user on 2023/05/08.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            
            Button("Show image picker") {
                showImagePicker = true
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
}

