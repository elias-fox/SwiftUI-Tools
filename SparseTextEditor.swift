//
//  SparseTextEditor.swift
//  Shoutput-SUI
//
//  Created by Elias Fox on 11/7/20.
//

import SwiftUI

struct SparseTextEditor: View {
    @Environment(\.verticalSizeClass) private var verticalSize
    @Binding var text: String
    
    private let minHeight: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize
    @State private var currentHeight: CGFloat?
    let maxHeight: CGFloat?
    let maxHeightCompact: CGFloat?
    let placeholder: String?
    
    private let placeholderPadding: CGFloat = 4
    
    init(text: Binding<String>, placeholder: String? = nil, maxHeight: CGFloat? = nil, maxHeightCompact: CGFloat? = nil) {
        self._text = text
        self.maxHeight = maxHeight
        self.maxHeightCompact = maxHeightCompact
        self.placeholder = placeholder
    }
    
    var body: some View {
        DelegatedTextView(text: $text, textDidChange: textDidChange(_:))
            .frame(height: frameHeight)
            .background(Text(placeholder ?? "")
                            .foregroundColor(.secondaryLabel)
                            .opacity(text.count == 0 ? 1.0 : 0)
                            .padding(.leading, placeholderPadding),
                        alignment: .leading)
    }
    
    private var frameHeight: CGFloat {
        if verticalSize == .compact, let maxHeightCompact = maxHeightCompact {
            return min(currentHeight ?? minHeight, maxHeightCompact)
        } else if let maxHeight = maxHeight {
            return min(currentHeight ?? minHeight, maxHeight)
        } else {
            return currentHeight ?? minHeight
        }
    }
    
    private func textDidChange(_ textView: UITextView) {
        currentHeight = textView.contentSize.height
    }
}
