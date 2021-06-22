//
//  PhotoPicker.swift
//  Wome
//
//  Created by Maxim Soroka on 01.06.2021.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var pickeedAssets: [Asset]
    @Binding var pickedAssets: [UIImage]
    @Binding var isShown: Bool
    
    let selectionLimit: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = selectionLimit
        configuration.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }

    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(with parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isShown = false
            
            guard !results.isEmpty else { return }
           
            for result in results {
                let itemProvider = result.itemProvider
             
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                      let utType = UTType(typeIdentifier)
                else { continue }
                 
                if utType.conforms(to: .image) {
                    self.getPhoto(from: itemProvider)
                }
//                else if utType.conforms(to: .movie) {
//                    self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
//                }
                else {
                    getPhoto(from: itemProvider)
                }
            }
        }
        
        private func getPhoto(from itemProvider: NSItemProvider) {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
         
                    if let image = object as? UIImage {
                        DispatchQueue.main.async { [weak self] in
                            withAnimation {
                                if self?.parent.selectionLimit == 1 {
                                    self?.parent.pickedAssets = []
                                    self?.parent.pickeedAssets = []
                                    self?.parent.pickedAssets.append(image)
                                    self?.parent.pickeedAssets.append(Asset(image: image))
                                }  else {
                                    self?.parent.pickedAssets.append(image)
                                    self?.parent.pickeedAssets.append(Asset(image: image))
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
//            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//
//                guard let url = url else { return }
//
//                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//                guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
//
//                do {
//                    if FileManager.default.fileExists(atPath: targetURL.path) {
//                        try FileManager.default.removeItem(at: targetURL)
//                    }
//
//                    try FileManager.default.copyItem(at: url, to: targetURL)
//
//                    DispatchQueue.main.async { [weak self] in
//                        if let image = self?.parent.getThumbnailImage(forUrl: targetURL) {
//                            self?.parent.pickeedAssets?.append(image)
//                        }
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
}
