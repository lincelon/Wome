//
//  AutoSizingTextField.swift
//  Wome
//
//  Created by Maxim Soroka on 31.05.2021.
//

import SwiftUI

struct AutoSizingTextField: UIViewRepresentable {
    let placeholder: String
    let font: UIFont
    let isTextView: Bool

    @Binding var text: String
    @Binding var containerHeight: CGFloat 
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.text = placeholder
        textView.textColor = UIColor.placeholderText
        textView.backgroundColor = .clear

        textView.delegate = context.coordinator
        
        if isTextView {
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            toolBar.barStyle = .default
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.closeKeyBoard))
            
            toolBar.items = [spacer, doneButton]
            toolBar.sizeToFit()
            textView.inputAccessoryView = toolBar
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            containerHeight = uiView.contentSize.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        private let parent: AutoSizingTextField
        
        init(parent: AutoSizingTextField) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = UIColor(Color.primary)
            }
        }
    
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if (text == "\n" && !parent.isTextView) {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            if textView.contentSize.height >= parent.containerHeight {
                parent.containerHeight = textView.contentSize.height
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) { 
            if textView.text == "" {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
            }
        }
        
        @objc func closeKeyBoard() {
            UIApplication
                .shared
                .sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
        }
    }
}
