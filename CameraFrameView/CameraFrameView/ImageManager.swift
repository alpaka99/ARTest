//
//  ImageManager.swift
//  CameraFrameView
//
//  Created by user on 2023/05/11.
//

import Photos
import UIKit

class ImageManager:ObservableObject {
//    static let shared = ImageManager()
    
    @Published var loadedItem: PHFetchResult<PHAsset> = PHFetchResult() {
        didSet {
            print("Object changed")
            print(loadedItem.count)
            objectWillChange.send()
        }
        
        willSet {
            print("Object will change")
            print(loadedItem.count)
        }
    }
    
    private let imageManager = PHImageManager()
    var requestImageOption = PHImageRequestOptions()
    
    var successHandler: ((UIImage) -> Void)?
    var errorHandler: ((Error) -> Void)?

    
    init() {
        setRequestImageOptions()
    }
    
    func requestImage(from asset: PHAsset, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 120, height: 120), contentMode: .aspectFill, options: requestImageOption) { image, info in
            completion(image)
        }
    }
    
    func requestDetailImage(from asset: PHAsset, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 360, height: 480), contentMode: .aspectFill, options: requestImageOption) { image, info in
            completion(image)
        }
    }
    
    func setRequestImageOptions() {
        requestImageOption.isSynchronous = true
        requestImageOption.deliveryMode = .highQualityFormat
        requestImageOption.resizeMode = PHImageRequestOptionsResizeMode.exact
    }
    
    func saveSnapShot(snapShot: UIImage, completion: @escaping () -> Void) {
        UIImageWriteToSavedPhotosAlbum(snapShot, nil, #selector(saveCompleted), nil)
        completion()
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                errorHandler?(error)
            } else {
                successHandler?(image)

            }
        }
    
    
    func loadPHAsset(completion: @escaping () -> Void) {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        loadedItem = fetchPhotos
        completion()
    }
}
