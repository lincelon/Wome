//
//  ScrollableTabBar.swift
//  Wome
//
//  Created by Maxim Soroka on 14.06.2021.
//

import SwiftUI

struct ScrollableTabBar<Content: View>: UIViewRepresentable {
    let tabsCount: CGFloat
    let scrollView = UIScrollView()
    let content: Content
    let rect: CGRect
    
    @Binding var offset: CGFloat

    init(
        tabsCount: CGFloat,
        rect: CGRect,
        offset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self._offset = offset
        self.rect = rect
        self.tabsCount = tabsCount
    }
    
    func makeCoordinator() -> Coordinator {
        return .init(parent: self)
    }
    
    func makeUIView(context: Context) ->  UIScrollView {
        setUpScrollView()
        
        scrollView.contentSize = CGSize(width: rect.width * tabsCount, height: rect.height)
        scrollView.addSubview(extractView())
        scrollView.delegate = context.coordinator
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if uiView.contentOffset.x != offset{
            uiView.delegate = nil
            
            UIView.animate(withDuration: 0.4) {
                uiView.contentOffset.x = offset
            } completion: { (status) in
                if status{ uiView.delegate = context.coordinator }
            }
        }
    }
    
    private func setUpScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
     
    private func extractView()->UIView {
        let controller = UIHostingController(
            rootView:  HStack(spacing: 0) {
                content
            }
        )
        controller.view.frame = CGRect(x: 0, y: 0, width: rect.width * tabsCount, height: rect.height)
        
        return controller.view!
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        private let parent: ScrollableTabBar
        
        init(parent: ScrollableTabBar) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
    }
}
