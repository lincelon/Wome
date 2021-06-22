//
//  PageControl.swift
//  Wome
//
//  Created by Maxim Soroka on 05.06.2021.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    @Binding var maxPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.backgroundStyle = .minimal
        pageControl.numberOfPages = maxPages
        pageControl.currentPage = currentPage
        
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
}
