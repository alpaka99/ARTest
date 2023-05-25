//
//  ViewController.swift
//  RaycastTest
//
//  Created by user on 2023/05/04.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
//    let model01 = try! Entity.load(named: "Paperbag_Mask")
    let model01 = try! Entity.load(named: "Tomatilo_FaceFilter")
//    let model02 = try! Experience.loadBox()
//    let model02 = try! Entity.load(named: "Floating_Fox")
    let model02 = try! TomatiloFaceFilter2.load장면()
    let model03 = try! Entity.load(named: "Tomatilo_FaceFilter3")
    
    lazy var models: [Any] = [self.model01, self.model02, self.model03]
//    lazy var models: [Any] = [self.model01, self.model02]

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        arView = ARView()
        
        arView = setupARView()
        view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            arView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 3
        arView.contentScaleFactor = 0.75 * arView.contentScaleFactor
        arView.session.run(configuration)
    }
    
    func setupARView() -> ARView {
        let frameRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let arView = ARView(frame: frameRect)
        arView.session.delegate = self
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }
    
    func startFaceDetection() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.maximumNumberOfTrackedFaces = 3
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func takeSnapShot() {
        print("Snapshot taken")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.arView.snapshot(saveToHDR: false) { (image) in
                let compressedImage = UIImage(data: (image?.pngData())!)
                
                UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            }
        }
    }
    
}

extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//        arView.scene.anchors.removeAll()
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
           
        for i in (0..<anchors.count) {
            let faceAnchor = anchors[i] as? ARFaceAnchor
            let anchor = AnchorEntity(anchor: faceAnchor!)
            anchor.addChild(models[i] as! Entity)
            arView.scene.anchors.append(anchor)
        }
    }
}



