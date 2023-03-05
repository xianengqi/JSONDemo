//
//  ExampleGeomery.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/3/5.
//

import SwiftUI

struct ExampleGeomery: View {
    @State private var text = "Hello, world!Hello, world!Hello, world!"
    
    var body: some View {
        VStack {
            Text(text)
                .padding()
                .overlay(
                    ZStack(alignment: .bottomTrailing) {
                        GeometryReader { geometry in
                            Color.clear
                                .preference(key: TextWidthKey.self, value: geometry.size.width)
                        }
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                    }
                )
        }
        .onPreferenceChange(TextWidthKey.self) { width in
            print("Text width: \(width)")
        }
    }
}

struct TextWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}


struct ExampleGeomery_Previews: PreviewProvider {
    static var previews: some View {
        ExampleGeomery()
    }
}
