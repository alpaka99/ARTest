//
//  ViewController.swift
//  ARFaceTrackingUIKit
//
//  Created by user on 2023/05/08.
//

import Foundation
import SwiftUI

struct ARViewContainer: UIViewControllerRepresentable {
    
    let vc = ViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func takeSnapShot() {
        vc.takeSnapShot()
    }
    
}
