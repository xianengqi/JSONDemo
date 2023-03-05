//
//  DetailView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/3/5.
//

import SwiftUI

struct DetailView: View {
  var colors: [String]
     var body: some View {
         VStack {
             ForEach(colors, id: \.self) { color in
                 Text(color)
             }
         }
     }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
