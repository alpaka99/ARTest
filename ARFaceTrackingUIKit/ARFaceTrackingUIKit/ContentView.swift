//
//  ContentView.swift
//  ARFaceTrackingUIKit
//
//  Created by user on 2023/05/08.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    let arViewContainer = ARViewContainer()
    var body: some View {
        VStack {
            arViewContainer.edgesIgnoringSafeArea(.all)
            
            Button("Press to save") {
                arViewContainer.takeSnapShot()
            }
        }
    }
}

