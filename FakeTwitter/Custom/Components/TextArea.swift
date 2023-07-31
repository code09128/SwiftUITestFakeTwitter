//
//  TextAreaView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//

import SwiftUI

struct TextArea: View {
    @Binding
    var text: String
    
    let placeholder: Text
    
    /// 初始化設置元件
    /// - Parameters:
    ///   - text: 輸入的文字
    ///   - placeholder: 未輸入文字顯示的文字訊息
    init(text: Binding<String>,placeholder: Text) {
        self._text = text
        self.placeholder = placeholder
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
//        ZStack(alignment: .topLeading) {
//
//            if text.isEmpty {
//                placeholder
//                    .foregroundColor(Color(.placeholderText))
//                    .padding(.horizontal,8)
//                    .padding(.vertical,8)
//            }
//
//            TextEditor(text: $text)
//                .padding(5)
//        }
////        .padding(10)
//
//        .font(.body)
        
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(.gray.opacity(0.4))
//                    .font(.system(size: 50))
            }
            
            TextField("", text: $text)
//                .font(.system(size: 50))
        }
        .padding(10)
    }
}

