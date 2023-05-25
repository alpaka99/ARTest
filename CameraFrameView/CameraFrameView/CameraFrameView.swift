//
//  CameraFrameView.swift
//  CameraFrameView
//
//  Created by user on 2023/05/09.
//

import SwiftUI
import RealityKit
import ARKit
//import Photos
import PhotosUI

struct CameraFrameView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var imageManager = ImageManager()
    
    @State private var geoWidth = 0.0
    @State private var geoHeight = 0.0
    @State private var geoPosition = CGPoint()
    @State private var soundOn = true
    @State private var shutterEffect = false
    
//    @State var loadedItem: PHFetchResult<PHAsset> = PHFetchResult()
//    @State var loadedItem: PHFetchResult<PHAsset> = ImageManager.shared.loadedItem
    

    @State var showSnapShotView = false
    @State var showPhotoLibrary = false
    @State var tempSnapShot: UIImage? = nil
    @State var thumbnail: UIImage? = nil {
        willSet {
            print("Main thumbnail will change")
            print(thumbnail)
        }
        
        didSet {
            print("Main thumbnail did change")
            print(thumbnail)
            print()
        }
    }
    
    
    var arViewContainer = ARViewContainer()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button {
                            soundOn.toggle()
                        } label: {
                            if soundOn {
                                Image(systemName: "speaker.wave.2.fill")
                            } else {
                                Image(systemName: "speaker.slash.fill")
                            }
                        }
                        .padding()
                    }
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    
                    GeometryReader { proxy in
                        arViewContainer
                            .onAppear {
                                geoWidth = proxy.size.width
                                geoHeight = proxy.size.height
                                geoPosition = proxy.frame(in: .global).origin
                            }
                            .brightness(shutterEffect ? -1 : 0)
                    }
                    
                    HStack {
                        if thumbnail != nil {
                            Button {
                                showPhotoLibrary = true
                            } label: {
                                Image(uiImage: thumbnail!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit )
                                    .frame(width: 65, height: 65)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            Button {
                                showPhotoLibrary = true
                            } label: {
                                Image("ExampleCat")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 65, height: 65)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            if soundOn {
                                SoundPlayer.soundPlayer.play(fileName: "ShutterSound")
                            }
                            
                            // haptic
                            let haptic = UIImpactFeedbackGenerator(style: .rigid)
                            haptic.impactOccurred()
                            
                            // shutter effect
                            withAnimation(.easeInOut(duration: 0.1)) {
                                shutterEffect = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    self.shutterEffect = false
                                }
                                
                                // snapshot
                                Task {
                                    takeSnapShot(position: geoPosition, width: geoWidth, height: geoHeight) { croppedImage in
                                        tempSnapShot = croppedImage
                                        showSnapShotView = true
                                    }
//                                    showSnapShotView = true
                                }
                            }
                            
                            
                            
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(lineWidth: 5)
                                    .frame(width: 75, height: 75)
                            }
                        }
                        
                        Spacer()
                        
                        Button("") {
                            
                        }
                        .frame(width: 65, height: 65)
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .onAppear {
                        print("Appear")
                        setPhotoLibraryImage() { image in
                            thumbnail = image
                        }
                    }
                    
                }
                
                NavigationLink("", isActive: $showSnapShotView) {
                    TempSnapShotView(imageManager: imageManager, thumbnail: $thumbnail, arViewContainer: arViewContainer)
                }
                
                NavigationLink("", isActive: $showPhotoLibrary) {
                    PhotoLibraryView(showPhotoLibrary: $showPhotoLibrary, imageManager: imageManager, arViewContainer: arViewContainer, loadedItem: imageManager.loadedItem)
                }
                
            }
        }
        
    }
    
    func loadPHAsset(completion: @escaping () -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        imageManager.loadedItem = fetchPhotos
        completion()
    }
    
    func takeSnapShot(position: CGPoint, width: CGFloat, height: CGFloat, completionHandler: @escaping (UIImage) -> Void ) {
        self.arViewContainer.arView.snapshot(saveToHDR: false) { (image) in
                let compressedImage = UIImage(data: (image?.pngData())!)
                completionHandler(compressedImage!)
            }
        }
    
    func setPhotoLibraryImage(completion: @escaping (UIImage?) -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 1
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        if let photo = fetchPhotos.firstObject {
                imageManager.requestImage(from: photo, thumbnailSize: CGSize(width: 40, height: 40)) { image in
                    completion(image)
            }
        }
    }
}

extension UIImage {
    func crop(rect: CGRect) -> UIImage? {
        var scaledRect = rect
        scaledRect.origin.x *= scale
        scaledRect.origin.y *= scale
        scaledRect.size.width *= scale
        scaledRect.size.height *= scale
        
        guard let imageRef: CGImage = cgImage?.cropping(to: scaledRect) else {
            return nil
        }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation )
    }
}

extension UIImage: Identifiable {
    public var id: String {
        UUID().uuidString
    }
}



struct CameraFrameView_Previews: PreviewProvider {
    static var previews: some View {
        CameraFrameView()
    }
}


struct TempSnapShotView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var imageManager: ImageManager
//    @Binding var showSnapShotView: Bool
    @Binding var thumbnail: UIImage? {
        willSet {
            print("Thumbnail will change")
            print(thumbnail)
        }
        
        didSet {
            print("Thumbnail did change")
//            showSnapShotView = false
            print(thumbnail)
        }
    }
    
    var tempSnapShot: UIImage?

    let arViewContainer: ARViewContainer
    
    var body: some View {
        ZStack {
            Color(.black)
            
            VStack {
                Image(uiImage: tempSnapShot!)
                    .resizable()
                    .scaledToFit()
                
                HStack(alignment: .center) {
                    Button {
                        DispatchQueue.main.async {
                            imageManager.saveSnapShot(snapShot: tempSnapShot!) {
                                thumbnail = tempSnapShot
                                
                                //                                loadPHAsset()
                                //                                setPhotoLibraryImage { image in
                                //                                    print("Changing thumbnail from childView")
                                //                                        thumbnail = image
                                //                                    }
                                //                                }
                            }
                               dismiss()
                        }
                    } label : {
                        Text("Save")
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Delete")
                    }
                    .padding()
                    .background(.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundColor(.white)
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            arViewContainer.arView.session.pause()
        }
        .onDisappear {
            
            arViewContainer.arView.reRun()
        }
    }
    
    func loadPHAsset() {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        imageManager.loadedItem = fetchPhotos
//        completion()
    }
    
    func takeSnapShot(position: CGPoint, width: CGFloat, height: CGFloat, completionHandler: @escaping (UIImage) -> Void ) {
        self.arViewContainer.arView.snapshot(saveToHDR: false) { (image) in
                let compressedImage = UIImage(data: (image?.pngData())!)
                completionHandler(compressedImage!)
            }
        }
    
    func setPhotoLibraryImage(completion: @escaping (UIImage?) -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 1
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        if let photo = fetchPhotos.firstObject {
            imageManager.requestImage(from: photo, thumbnailSize: CGSize(width: 40, height: 40)) { image in
                completion(image)
            }
        }
    }
}

