//
//  CustomInputFieldView.swift
//  FakeTwitter
//
//  Created by Dustin on 2023/7/11.
//

import SwiftUI

struct CustomInputFieldView: View {
    let imageName: String
    let placeholderText: String
    var isSecureField:Bool? = false
    
    @Binding
    var text: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                
                if isSecureField ?? false {
                    SecureField(placeholderText, text: $text)
                }
                else {
                    TextField(placeholderText, text: $text)
                }
            }
            
            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomInputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputFieldView(imageName: "envelope", placeholderText: "Email",isSecureField: false, text: .constant(""))
    }
}
