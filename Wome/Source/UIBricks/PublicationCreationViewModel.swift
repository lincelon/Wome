//
//  PublicationCreationViewModel.swift
//  Wome
//
//  Created by Maxim Soroka on 30.05.2021.
//

import UIKit
import Combine

final class PublicationCreationViewModel: ObservableObject {
    //MARK: - Publication creation fields
    @Published var titleText: String = "" 
    @Published var captionText: String = ""
    @Published var titleContainerHeight: CGFloat = 0
    @Published var captionContainerHeight: CGFloat = 0
    
    //MARK: - AssetsViewer
    @Published var showPhotoPicker: Bool = false
    @Published var showAssetsViewer: Bool = false
    @Published var selectedAsset: Asset = Asset(image: UIImage())
    @Published var selectedAssets: [Asset] = []
    
    @Published private(set) var captionTextValidation: FormValidation = FormValidation()
    @Published private(set) var selectedAssetsValidation: FormValidation = FormValidation()
    @Published private(set) var emptyValidation: FormValidation = FormValidation()
    @Published var showErrorView: Bool = false
    @Published private(set) var canPublish: Bool = false
    
    @Published var assetsViewerOffset: CGSize = .zero
    @Published var backgroundOpacity: Double = 1
    
    @Published var generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    //MARK: - PublicationTypeSelection
    @Published var storyAnimationProgress: CGFloat = 0
    @Published var postAnimationProgress: CGFloat = 0
    @Published private(set) var onApearAnimationStart = false
    @Published private(set) var selectedPublicationType: PublicationTypeSelection = .story
    
    private var cancellables: [AnyCancellable] = []

    
    func send(action: Action, completion: @escaping ([Publication]) -> () = { _ in }) {
        switch action {
        case .deleteAsset(let asset):
            
            selectedAssets
                .removeAll { asset.id == $0.id }
            
        case .createPublication(let publications):
            var x = publications
            
            switch selectedPublicationType {
            case .story:
                x.append(
                    .init(type: .story(
                        .init(title: titleText == "" ? nil : titleText,
                              caption: captionText == "" ? nil : captionText,
                              images: selectedAssets.isEmpty ? nil : selectedAssets)
                        )
                    )
                )
            case .post:
                x.append(
                    .init(type: .post(
                        .init(
                              caption: captionText == "" ? nil : captionText,
                              image: selectedAssets.isEmpty ? nil : selectedAssets.first ?? Asset(image: UIImage()))
                        )
                    )
                )
            }
            completion(x)
            
        case .publicationTypeSelected(let type): 
            selectedPublicationType = type
            
            switch type {
            case .story:
                storyAnimationProgress = 1
                postAnimationProgress = 0
            case .post:
                postAnimationProgress = 1
                storyAnimationProgress = 0
            }
        }
    }
    
    init() {
        captionPublisher
            .assign(to: \.captionTextValidation, on: self)
            .store(in: &cancellables)
        
        selectedAssetsPublisher
            .assign(to: \.selectedAssetsValidation, on: self)
            .store(in: &cancellables)
        
        emptyPublisher
            .assign(to: \.emptyValidation, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest3(captionPublisher, selectedAssetsPublisher, emptyPublisher)
            .map { $0.isSucceed && $1.isSucceed && $2.isSucceed}
            .assign(to: \.canPublish, on: self)
            .store(in: &cancellables)
    }
}

//MARK: - Publishers
extension PublicationCreationViewModel {
    private var captionPublisher: AnyPublisher<FormValidation, Never> {
        Publishers.CombineLatest($captionText, $selectedPublicationType)
            .map { text, type in
                let length = 250
                
                if text.count > length && type == .post {
                    return FormValidation(
                        isSucceed: false,
                        message: "The Shop Post must not contain more than \(length) characters"
                    )
                }
                
                return FormValidation(isSucceed: true, message: nil)
            }
            .eraseToAnyPublisher()
    }
    
    private var selectedAssetsPublisher: AnyPublisher<FormValidation, Never> {
        Publishers.CombineLatest($selectedAssets, $selectedPublicationType)
            .map { assets, type in
                if assets.count > 1 && type == .post {
                    return FormValidation(
                        isSucceed: false,
                        message: "The Shop Post must not contain more than 1 asset"
                    )
                }
                
                return FormValidation(isSucceed: true, message: nil)
            }
            .eraseToAnyPublisher()
    }
    
    
    private var emptyPublisher: AnyPublisher<FormValidation, Never> {
        Publishers.CombineLatest3($captionText, $selectedAssets, $titleText)
            .map { caption, selectedAssets, title in
                if caption.isEmpty && selectedAssets.isEmpty {
                    return FormValidation(
                        isSucceed: false,
                        message: "You must either add assets or caption with title"
                    )
                } else if !title.isEmpty && (caption.isEmpty || selectedAssets.isEmpty)  {
                    return FormValidation(
                        isSucceed: false,
                        message: "You must either add assets or caption with title"
                    )
                }

                return FormValidation(isSucceed: true, message: nil)
            }
            .eraseToAnyPublisher()
    }
}

extension PublicationCreationViewModel {  
    enum Action {
        case publicationTypeSelected(type: PublicationTypeSelection)
        case deleteAsset(asset: Asset)
        case createPublication(publications: [Publication])
    }
    
    enum PublicationTypeSelection: String, CaseIterable {
        case story = "Story"
        case post = "Shop Post"
    }
}
