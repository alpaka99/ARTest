//
//  PhotoLibraryView.swift
//  CameraFrameView
//
//  Created by user on 2023/05/11.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryView: View {
    @Binding var showPhotoLibrary: Bool
    @ObservedObject var imageManager: ImageManager
    
    var arViewContainer: ARViewContainer
    
    var columns: [GridItem] {
        return Array(repeating: .init(.flexible()), count: 3)
    }
    
    @State var loadedItem: PHFetchResult<PHAsset>
    @State private var showDetailImage = false
    @State private var detailImageIndex: Int = 0
    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<loadedItem.count, id: \.self) { index in
                            let thumbnailImage =  fetchThumbnailImage(index: index)
                            
                            if thumbnailImage != nil {
                                Image(uiImage: thumbnailImage!)
                                    .onTapGesture {
                                        detailImageIndex = index
                                        showDetailImage = true
                                    }
                            } else {
                                Image("ExampleCat")
                                }
                            }
                        }
                    }
                }
            .onAppear {
                setPhotoLibraryImage() {
                }
            }
        }
        .background(.black)
        .onAppear {
            arViewContainer.arView.session.pause()
        }
        .onDisappear {
            arViewContainer.arView.reRun()
        }
    }
    
    func setPhotoLibraryImage(completion: @escaping () -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
//        print(type(of: fetchPhotos))
        loadedItem = fetchPhotos
    }
    
    func fetchThumbnailImage(index: Int) -> UIImage? {
        var returnImage: UIImage?

        if index > loadedItem.count - 1 {
            print("List index out of bound")
            return nil
        }

//        ImageManager.shared.requestImage(from: loadedItem[index], thumbnailSize: CGSize(width: 40, height: 40)) { image in
//            returnImage = image
//        }
        imageManager.requestImage(from: loadedItem[index], thumbnailSize: CGSize(width: 40, height: 40)) { image in
            returnImage = image
        }


//        print(returnImage)
        return returnImage
    }
    
    func fetchDetailImage(index: Int) -> UIImage? {
        var returnImage: UIImage?

        if index > loadedItem.count - 1 {
            print("List index out of bound")
            return nil
        }
        
//        ImageManager.shared.requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat

//        ImageManager.shared.requestDetailImage(from: loadedItem[index], thumbnailSize: CGSize(width: 40, height: 40)) { image in
//            returnImage = image
//        }
        
        imageManager.requestDetailImage(from: loadedItem[index], thumbnailSize: CGSize(width: 40, height: 40)) { image in
            returnImage = image
        }


        print(returnImage)
        return returnImage!
    }

}

//struct PhotoLibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoLibraryView(showPhotoLibrary: Binding(true))
//    }
//}


extension GridItem: Hashable {
    public static func == (lhs: GridItem, rhs: GridItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }

}


struct DetailImageView: View {
    @Environment(\.dismiss) var dismiss
    let detailImage: UIImage?
    
    
    var body: some View {
        ZStack {
            Color(.black)
            
            if detailImage != nil {
                Image(uiImage: detailImage!)
                    .resizable()
                    .scaledToFit()
            } else {
                Image("ExampleImage")
                    .resizable()
                    .scaledToFit()
            }
        }
        .onTapGesture {
            dismiss()
        }
    }
}
