////
////  ImagePicker.swift
////  ImageToARTest
////
////  Created by user on 2023/05/08.
////
//
//import Foundation
//import PhotosUI
//import SwiftUI
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var imageURL: URL?
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.preferredAssetRepresentationMode = .current
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            var selectedPhotosData: [Data] = []
//
//            for (index, result) in results.enumerated() {
//                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.jpeg") {(url, error) in
//
//                    guard let fileURL = url else {
//                        return }
//
//                    self.parent.imageURL = fileURL
//
//                    DispatchQueue.main.async {
//                        picker.dismiss(animated: true)
//                    }
//                }
//            }
//        }
//    }
//}


import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }
            
            print(results)
//            if provider.canLoadObject(ofClass: UIImage.self) {
//                provider.loadObject(ofClass: UIImage.self) { image, _ in
//                    self.parent.image = image as? UIImage
//                }
//            }
        }
    }
}
