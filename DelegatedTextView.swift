//
//  DelegatedTextView.swift
//  Shoutput-SUI
//
//  Created by Elias Fox on 10/25/20.
//

import SwiftUI

struct DelegatedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    
    let textDidChange: ((UITextView) -> Void)?
    let textShouldBeginEditing: ((UITextView) -> Bool)?
    let textDidBeginEditing: ((UITextView) -> Void)?
    let textShouldEndEditing: ((UITextView) -> Bool)?
    let textDidEndEditing: ((UITextView) -> Void)?
    let textDidChangeSelection: ((UITextView) -> Void)?
    let textShouldInteractWithAttachment: ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)?
    let textShouldInteractWithURL: ((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?
    
    init(text: Binding<String>,
         textDidChange: ((UITextView) -> Void)? = nil,
         textShouldBeginEditing: ((UITextView) -> Bool)? = nil,
         textDidBeginEditing: ((UITextView) -> Void)? = nil,
         textShouldEndEditing: ((UITextView) -> Bool)? = nil,
         textDidEndEditing: ((UITextView) -> Void)? = nil,
         textDidChangeSelection: ((UITextView) -> Void)? = nil,
         textShouldInteractWithAttachment: ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)? = nil,
         textShouldInteractWithURL: ((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)? = nil) {
        self._text = text
        self.textDidChange = textDidChange
        self.textShouldBeginEditing = textShouldBeginEditing
        self.textDidBeginEditing = textDidBeginEditing
        self.textShouldEndEditing = textShouldEndEditing
        self.textDidEndEditing = textDidEndEditing
        self.textDidChangeSelection = textDidChangeSelection
        self.textShouldInteractWithAttachment = textShouldInteractWithAttachment
        self.textShouldInteractWithURL = textShouldInteractWithURL
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.delegate = context.coordinator
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.textDidChange?(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text,
                           textDidChange: textDidChange,
                           textShouldBeginEditing: textShouldBeginEditing,
                           textDidBeginEditing: textDidBeginEditing,
                           textShouldEndEditing: textShouldEndEditing,
                           textDidEndEditing: textDidEndEditing,
                           textDidChangeSelection: textDidChangeSelection,
                           textShouldInteractWithAttachment: textShouldInteractWithAttachment,
                           textShouldInteractWithURL: textShouldInteractWithURL)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: ((UITextView) -> Void)?
        let textShouldBeginEditing: ((UITextView) -> Bool)?
        let textDidBeginEditing: ((UITextView) -> Void)?
        let textShouldEndEditing: ((UITextView) -> Bool)?
        let textDidEndEditing: ((UITextView) -> Void)?
        let textDidChangeSelection: ((UITextView) -> Void)?
        let textShouldInteractWithAttachment: ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)?
        let textShouldInteractWithURL: ((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?

        init(text: Binding<String>,
             textDidChange: ((UITextView) -> Void)?,
             textShouldBeginEditing: ((UITextView) -> Bool)?,
             textDidBeginEditing: ((UITextView) -> Void)?,
             textShouldEndEditing: ((UITextView) -> Bool)?,
             textDidEndEditing: ((UITextView) -> Void)?,
             textDidChangeSelection: ((UITextView) -> Void)?,
             textShouldInteractWithAttachment: ((UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool)?,
             textShouldInteractWithURL: ((UITextView, URL, NSRange, UITextItemInteraction) -> Bool)?) {
            self._text = text
            self.textDidChange = textDidChange
            self.textShouldBeginEditing = textShouldBeginEditing
            self.textDidBeginEditing = textDidBeginEditing
            self.textShouldEndEditing = textShouldEndEditing
            self.textDidEndEditing = textDidEndEditing
            self.textDidChangeSelection = textDidChangeSelection
            self.textShouldInteractWithAttachment = textShouldInteractWithAttachment
            self.textShouldInteractWithURL = textShouldInteractWithURL
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange?(textView)
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            return textShouldBeginEditing?(textView) ?? true
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textDidBeginEditing?(textView)
        }
        
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            return textShouldEndEditing?(textView) ?? true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            textDidEndEditing?(textView)
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            textDidChangeSelection?(textView)
        }
        
        func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            return textShouldInteractWithAttachment?(textView, textAttachment, characterRange, interaction) ?? true
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            return textShouldInteractWithURL?(textView, URL, characterRange, interaction) ?? true
        }
    }
}
