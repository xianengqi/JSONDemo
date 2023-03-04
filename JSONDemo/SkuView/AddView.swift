//
//  AddView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/27.
//

import CoreData
import Flow
import SwiftUI

// 点击颜色， 用Sheet显示
// 点击尺码, 用Sheet显示
@available(iOS 16.4, *)
struct AddView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @State private var selectedColors: [String] = []
  @State var showColor = false
  @State var showSize = false

  var body: some View {
    ZStack {
      // 设置全局颜色
      Color(.white)
        .ignoresSafeArea()

      VStack(spacing: 0) {
        formColorView()
          .frame(height: 20)
          .padding()
        Spacer()

        Button(action: {
          saveColors()
        }, label: {
          Text("保存")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 40)
            .background(.blue)
            .cornerRadius(6)
            .padding()
        })
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
        Text(selectedColors.isEmpty ? "选择颜色" : "\(selectedColors.joined(separator: ", "))")
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
      ColorView(selectedColors: $selectedColors)
        .environment(\.managedObjectContext, viewContext)
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

  private func saveColors() {
    // 在CoreData中创建一个新的颜色对象
    let newColor = ColorEntity(context: viewContext)
    // 设置颜色的属性
    newColor.colors = selectedColors
    // 将颜色保存到CoreData中
    do {
      try viewContext.save()
    } catch {
      print("Error saving colors: (error)")
    }
  }
}

struct ColorView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) private var presentationMode
  @Binding var selectedColors: [String]
  @State private var phase = 0.0
  @State private var showingAlert = false
  @State private var deleteAlert = false
  @State private var name = ""
  // 声明一个保存所选颜色的数组
  @State private var selectedColors222: [String] = []
  // 创建一个空数组，然后把name里的值保存到空数组里面
  @State private var colors222: [ColorEntity] = []

  @FetchRequest(
    entity: ColorEntity.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ColorEntity.createdAt, ascending: true)]
  ) var colors: FetchedResults<ColorEntity>

  private func submit() {
    // 把颜色添加进来
    let newColor = ColorEntity(context: viewContext)
    newColor.colors = [name]
    newColor.isSelected = false
    colors222.append(newColor)

    do {
      try viewContext.save()
    } catch {
      print("Error saving color: \(error.localizedDescription)")
    }

    // 清空颜色
    name = ""
    print("You entered \(name)")
    print("You entered \(colors)")
  }

//  // 创建一个空数组，然后把name里的值保存到空数组里面
//  @State private var colors: [String] = []
//
//  private func submit() {
//    // 把颜色添加进来
//    colors.append(name)
//    // 清空颜色
//    name = ""
//    print("You entered \(name)")
//    print("You entered \(colors)")
//  }

  var body: some View {
    ZStack {
      Color(.white).ignoresSafeArea()
      VStack(spacing: 0) {
        Color.clear.overlay {
          header()
        }
        .frame(height: 70)

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
//      .frame(height: 70)
  }

  @ViewBuilder
  private func content() -> some View {
    HFlow(itemSpacing: 10, rowSpacing: 10) {
      // 循环显示颜色
      ForEach(colors, id: \.self) { color in

//        Text(color.colors.joined(separator: ", "))
//          .foregroundColor(.black)
//          .padding()
//          .frame(height: 30)
//          .contentShape(Rectangle())
//          .overlay(
//            RoundedRectangle(cornerRadius: 4)
//
//              .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1))
//              .opacity(0.5)
        ////              .frame(width: 80, height: 30)
//          )
        ZStack {
          // 显示颜色
          // 给Text添加外框
          RoundedRectangle(cornerRadius: 4)
            .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1))
            .opacity(0.5)
            .frame(width: 80, height: 30)
         
          Text(color.colors.joined(separator: ", "))
            .foregroundColor(.black)
            .font(.system(size: 12))
            .frame(height: 30)
            .contentShape(Rectangle())
          
          // 如果颜色已经被选择，则为其添加一个红色勾号
          if color.isSelected {
            RoundedRectangle(cornerRadius: 4)
              .strokeBorder(Color.red, style: StrokeStyle(lineWidth: 1))
              .opacity(0.5)
              .frame(width: 80, height: 30)

            // 给Image添加红色圆角
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.orange)
              .frame(width: 10, height: 10)
              .offset(x: 35, y: 10)
            
            Image(systemName: "checkmark")
              .resizable()
              .foregroundColor(.white)
              .frame(width: 8, height: 6)
              .offset(x: 35, y: 10)
            
          }
         
        }
        .contentShape(Rectangle())
        .onTapGesture {
          // 如果颜色已经被选择，则从selectedColors数组中删除它；否则，将其添加到数组中
          if selectedColors.contains(color.colors) {
            selectedColors.removeAll(where: { $0 == color.colors.first })
            color.isSelected = false
          } else {
            selectedColors.append(contentsOf: color.colors)
            color.isSelected = true
          }
          do {
            try viewContext.save()
          } catch {
            print("Error saving color: \(error.localizedDescription)")
          }
//          if color.colors.allSatisfy({ selectedColors222.contains($0) }) {
//            selectedColors222.removeAll(where: { $0 == color.colors.first })
//          } else {
//            selectedColors222.append(contentsOf: color.colors)
//          }
        }

        // 长按弹出提示删除框
        .onLongPressGesture {
//            colors.remove(at: colors.firstIndex(of: color)!)
          
          deleteAlert = true
//            print("长按删除\(colors)")
        }
        .alert("删除颜色", isPresented: $deleteAlert) {
          Button("确认删除") {
            // 从CoreData中删除颜色
            viewContext.delete(color)

            // 从colors数组中删除颜色
            colors222.removeAll(where: { $0 == color })

            // 从selectedColors数组中删除颜色
            selectedColors.removeAll(where: { $0 == color.colors.first ?? "" })

            do {
              try viewContext.save()
            } catch {
              print("Error deleting color: \(error)")
            }
          }
          Button("取消", role: .cancel) {}
        }
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
        .contentShape(Rectangle())

        .onTapGesture {
          showingAlert = true
        }
        .alert("新增颜色", isPresented: $showingAlert) {
          TextField("请输入颜色", text: $name)
          Button("确定", action: submit)
        }
    }
    .padding(8)

//    .frame(maxWidth: 300)
  }

  @ViewBuilder
  private func bottom() -> some View {
    VStack {
      Divider()

      HStack {
        Text("已选择：\(selectedColors.count)")
        Spacer()
        Button("保存") {
          print("已选择的颜色：\(selectedColors)")

          // 将选择的颜色和尺码清空，将显示另一个视图
//          selectedColors.removeAll()
          presentationMode.wrappedValue.dismiss()
        }
      }.padding()
    }
  }

  private func addColor() {
    // 在CoreData中创建一个新的颜色对象
    let newColor = ColorEntity(context: viewContext)
    // 设置颜色的属性
    newColor.colors = [name]
    // 将颜色保存到CoreData中
    do {
      try viewContext.save()
    } catch {
      print("Error saving color: (error)")
    }
    name = ""
    showingAlert = false
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
    
    AddView()
  
  }
}
