//
//  SelectedExample.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/3/6.
//

import SwiftUI

struct SelectedExample: View {
    @State private var colors: Set<String> = []

    let availableColors = ["Red", "Green", "Blue", "Orange", "Yellow"]

    var body: some View {
        VStack {
            ForEach(availableColors, id: \.self) { color in
                Button(action: {
                    if colors.contains(color) {
                        colors.remove(color)
                    } else {
                        colors.insert(color)
                    }
                }) {
                    HStack {
                        if colors.contains(color) {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "square")
                                .foregroundColor(.black)
                        }
                        Text(color)
                            .foregroundColor(.black)
                    }
                }
            }

            Button(action: {
                colors.removeAll()
            }) {
                Text("Clear")
                    .foregroundColor(.red)
            }
        }
    }
}


struct SelectedExample_Previews: PreviewProvider {
    static var previews: some View {
        SelectedExample()
    }
}
