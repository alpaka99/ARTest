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

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        arView = ARView()
        
        // 1. Fire off plane detection
        
        arView = setupARView()
        view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            arView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        startPlaneDetection()
        
        // 2. 2D point
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
    }
    
    func setupARView() -> ARView {
        let frameRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let cameraMode = ARView.CameraMode.ar
        
        let arView = ARView(frame: frameRect, cameraMode: cameraMode, automaticallyConfigureSession: false)
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }
    
    func startPlaneDetection() {
        arView.automaticallyConfigureSession = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        // Get touch location in ARView // done
        let tapLocation = recognizer.location(in: arView)
        print(tapLocation)
        
        // Convert 2D point into corresponding 3D point in real world
        // Raycast(2D -> 3D)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        print(results)
        if let firstResult = results.first {
            
            // 3D point (x, y, z)
            
            let worldPos = simd_make_float3(firstResult.worldTransform.columns.3)
            
            // Create sphere Entity
            let sphere = createSphere()
            
            
            // Place the sphere
            placeObject(object: sphere, at: worldPos)
        }
        
        func createSphere() -> ModelEntity {
            // Mesh
            let sphere = MeshResource.generateSphere(radius: 0.05)
            
            // Assing meterial
            let sphereMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
            
            
            // Model Entity
            let sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
            
            return sphereEntity
        }
        
        func placeObject(object: ModelEntity, at location: SIMD3<Float>) {
            // 1. Anchor
            let objectAnchor = AnchorEntity(world: location)
            
            // 2. Tie 3D model to Anchor
            objectAnchor.addChild(object)
            
            // 3. Add anchor to the scene along with the 
            arView.scene.addAnchor(objectAnchor)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
