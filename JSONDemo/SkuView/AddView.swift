//
//  AddView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/27.
//

import Flow
import SwiftUI

// 点击颜色， 用Sheet显示
// 点击尺码, 用Sheet显示
@available(iOS 16.4, *)
struct AddView: View {
  @State var showColor = false
  @State var showSize = false

  var body: some View {
    ZStack {
      // 设置全局颜色
      Color(.systemGray6)
        .ignoresSafeArea()

      VStack(spacing: 0) {
        formColorView()
          .frame(height: 20)
          .padding()
        Spacer()
      }

      .padding()
    }
  }

  @ViewBuilder
  func formColorView() -> some View {
    HStack {
      Color.clear.overlay {
        Text("颜色")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      Color.clear.overlay {
        Text("选择颜色")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      showColor = true
    }

    .sheet(isPresented: $showColor) {
      ColorView()
        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }

    HStack {
      Color.clear.overlay {
        Text("尺码")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      Color.clear.overlay {
        Text("选择尺码")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      showSize = true
    }

    .sheet(isPresented: $showSize) {
      SizeView()
        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }
  }
}

struct ColorView: View {
  @State private var phase = 0.0

  var body: some View {
    ZStack {
      Color(.white).ignoresSafeArea()
      VStack(spacing: 0) {
        Color.clear.overlay {
          header()
        }
        .frame(height: 60)

        Color.clear.overlay {
          content()
            .frame(maxHeight: .infinity, alignment: .top)
        }

        Color.clear.overlay {
          bottom()
        }
        .frame(height: 40)
      }
    }
  }

  @ViewBuilder
  private func header() -> some View {
    HStack(spacing: 0) {
      Color.clear.overlay {
        Text("选择颜色")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      Color.clear.overlay {
        Text("长按删除")
          .foregroundColor(.black)
          .opacity(0.6)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }.padding()
      .frame(height: 70)
  }

  @ViewBuilder
  private func content() -> some View {
    HFlow(itemSpacing: 14, rowSpacing: 10) {
      // 循环显示颜色
      ForEach(0 ..< 10) { _ in
        RoundedRectangle(cornerRadius: 4)
          .stroke(Color.black, lineWidth: 1)
          .opacity(0.5)
          .frame(width: 60, height: 30)
      }
      Text("新增颜色")
        .foregroundColor(Color.red)
        // 给文字添加红色外框
        .overlay(
          RoundedRectangle(cornerRadius: 4)

            .strokeBorder(Color.red, style: StrokeStyle(lineWidth: 1, dash: [4], dashPhase: phase))
            .frame(width: 80, height: 30)

            .onAppear {
              withAnimation(.linear.repeatForever(autoreverses: false)) {
                phase -= 10
              }
            }
        )
    }

//    .frame(maxWidth: 300)
  }

  @ViewBuilder
  private func bottom() -> some View {
    HStack(spacing: 0) {
      Text("确定")
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 40)
        .background(.blue)
        .cornerRadius(6)
        // 添加点击事件
        .onTapGesture {
          print("点击确定")
        }

    }.padding()
  }
}

struct SizeView: View {
  var body: some View {
    Text("尺码页面")
  }
}

@available(iOS 16.4, *)
struct AddView_Previews: PreviewProvider {
  static var previews: some View {
    ColorView()
  }
}
