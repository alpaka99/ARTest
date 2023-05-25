//
//  ContentView.swift
//  AR facetracking test
//
//  Created by user on 2023/05/06.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        VStack {
            ARViewContainer().edgesIgnoringSafeArea(.all)

            Button {
                ARViewContainer().takeSnapShot()
            } label: {
                Label("Capture", systemImage: "camera.circle")
            }
        }
    }
}


