//
//  ARViewModel.swift
//  ARTest
//
//  Created by user on 2023/05/01.
//

import Foundation
import RealityKit

class ARViewModel: ObservableObject {
    @Published private var model: ARModel = ARModel()
    
    var arView: ARView {
        model.arView
    }
    
    func switchCamera() {
        model.switchCamera()
    }
    
    func raycastFunc(location: CGPoint) {
        model.raycastFunc(location: location)
    }
}
