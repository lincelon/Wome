//
//  TestView.swift
//  Wome
//
//  Created by Maxim Soroka on 18.06.2021.
//

import SwiftUI
import WaterfallGrid

struct TestView: View {
    @StateObject private var viewModel = FeedViewModel ()
    @State private var color: [Color] = [
        .yellow, .orange, .red, .black, .green
    ]
    @State private var selectedColor: Color?
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                    ScrollView {
                        FeedHeaderView(showNavigationMenu: .constant(false), bounds: bounds)
                            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 7, y: 4)
                        
                            ForEach(color, id: \.self) { color in
                                VStack {
                                    if selectedColor == nil {
                                        VStack {
                                            color
                                        }
                                        .matchedGeometryEffect(id: "ID", in: animation)
                                        .frame(height: 300)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedColor = color
                                                   
                                            }
                                        }
                                    }
                                }
                                .animation(.default)
                            }
                            .padding()
                            .gridStyle(columns: 1, spacing: 16)
                    }
                    .background(Color.womeWhite)
                    .ignoresSafeArea()
                    
                    VStack {
                        if selectedColor != nil {
                            VStack {
                                selectedColor
                            }
                            .matchedGeometryEffect(id: "ID", in: animation)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                withAnimation {
                                    selectedColor = nil
                                }
                            }

                        }
                    }
                    
                }
            .environmentObject(viewModel)
        }
        }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
