//
//  AddView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/27.
//

import CoreData
import Flow
import SwiftUI

class SelectedColors: ObservableObject {
  @Published var colors: [String] = []
}

// 点击颜色， 用Sheet显示
// 点击尺码, 用Sheet显示
@available(iOS 16.4, *)
struct AddView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest(
    entity: ColorEntity.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ColorEntity.createdAt, ascending: true)],
    animation: .default
  )
  private var colorsFetchRequest: FetchedResults<ColorEntity>
  @State private var selectedColors: [String] = []
  @State private var selectedSizes: [String] = []
  @State var showColor = false
  @State var showSize = false
  @State private var isSaved = false
  @State private var linkDetail = false
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      ZStack {
        // 设置全局颜色
        Color(.white)
          .ignoresSafeArea()

        VStack(spacing: 0) {
          formColorView()
            .frame(height: 20)
            .padding()
          formTitleView()
            .frame(height: 20)
            .padding()
          Spacer()

          Text("确认新建")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 40)
            .background(.blue)
            .cornerRadius(6)
            .padding()
            .opacity(brandName.isEmpty ? 0.5 : 1.0)
            .disabled(brandName.isEmpty)
            .onTapGesture {
              print("保存品牌名称\(submit())")
              submit()
              self.linkDetail = true
              dismiss()
            }

//          NavigationLink(destination: DetailView(colors: selectedColors), isActive: $linkDetail) {
//            EmptyView()
//          }
          NavigationLink(destination: DetailExample(), isActive: $linkDetail) { EmptyView() }
        }
        .padding()
      }
    }
    .navigationBarBackButtonHidden(true)
  }

  @ViewBuilder
  func formColorView() -> some View {
    HStack {
      Color.clear.overlay {
        Text("颜色")
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(width: 40)

      Color.clear.overlay {
        Text(selectedColors.isEmpty ? "选择颜色" : "\(selectedColors.joined(separator: ", "))")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }.frame(width: 10)
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      print("点击弹出Sheet")
      // 在打开Sheet之前先将已选中的颜色状态清空
      selectedColors = []
      showColor = true
//      let isSelected = selectedColors.contains(color.colors)
//      isSelected = false
      // 清空选中的颜色状态
//      selectedColors.removeAll()
    }

    .sheet(isPresented: $showColor) {
      ColorView(selectedColors: $selectedColors)
        .onAppear {
          // 清空选中的颜色状态
          print("生命zhou")
          selectedColors.removeAll()
          // 把 isSelected状态设置为flase
        }
//        .environment(\.managedObjectContext, viewContext)
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
      }.frame(width: 40)

      Color.clear.overlay {
        Text(selectedSizes.isEmpty ? "选择尺码" : "\(selectedSizes.joined(separator: ", "))")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .center)
      }

      Color.clear.overlay {
        Image(systemName: "chevron.right")
          .foregroundColor(.black)
          .opacity(0.7)
          .frame(maxWidth: .infinity, alignment: .trailing)
      }.frame(width: 10)
    }
    // 整行点击状态
    .contentShape(Rectangle())

    .onTapGesture {
      showSize = true
    }

    .sheet(isPresented: $showSize) {
      SizeExample(selectedColors: $selectedSizes)
        .onAppear {
          // 清空选中的颜色状态
          print("生命zhou")
          selectedSizes.removeAll()
          // 把 isSelected状态设置为flase
        }
        .presentationDetents(
          [.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
        .presentationContentInteraction(.scrolls)
    }
  }

  @State private var brandName = ""

  @ViewBuilder
  func formTitleView() -> some View {
    VStack {
      HStack {
        Color.clear.overlay {
          Text("品名")
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        Color.clear.overlay {
          TextField("请输入品牌", text: $brandName)
            .foregroundColor(.red)
        }.offset(x: 30)
        Color.clear
      }
    }
  }

  private func submit() {
    // 把颜色添加进来
    let newColor = ProductEntity(context: viewContext)
    newColor.name = brandName
    print("品牌名称: \(String(describing: newColor.name))")

    do {
      try viewContext.save()
    } catch {
      print("Error saving color: \(error.localizedDescription)")
    }
    // 清空颜色
    brandName = ""
  }
}

struct ColorView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.presentationMode) private var presentationMode
  @Binding var selectedColors: [String]
//  @Binding var sheetSelected: Bool

//  @State private var selectedColors = [String]()

  @State private var phase = 0.0
  @State private var showingAlert = false
  @State private var deleteAlert = false
  @State private var isSelectedColor = false
  @State private var name = ""
  @State private var sizeClothes = ""
  @State private var deleteIndex: Int?
  @State private var colors333: [String] = []
//  @State private var isSelectionColor: Bool = false
  // 创建一个空数组，然后把name里的值保存到空数组里面
  @State private var colors222: [ColorEntity] = []

  @State private var isAppFirstLaunch: Bool = true

  @FetchRequest(
    entity: ColorEntity.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ColorEntity.createdAt, ascending: true)]
  ) var colors: FetchedResults<ColorEntity>

  @FetchRequest(
    entity: ColorEntity.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \ColorEntity.createdAt, ascending: true)],
    animation: .default
  )
  private var colorsFetchRequest: FetchedResults<ColorEntity>

  private func submit() {
    // 把颜色添加进来
    let newColor = ColorEntity(context: viewContext)
    newColor.colors = [name]
    colors222.append(newColor)

    do {
      try viewContext.save()
    } catch {
      print("Error saving color: \(error.localizedDescription)")
    }
    // 清空颜色
    name = ""
//    newColor.isSelected = false
    print("You entered \(name)")
    print("You entered \(colors)")
  }

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

  @State private var colorsSelected: Set<String> = []
  @State private var longPressIndex: Int?
  // 在ForEach中添加一个绑定状态变量用于跟踪删除选项
  @State private var deletingIndex: Int?

  private func deleteColor(at index: Int) {
    if let sizeToDelete = colors[index].colors.first {
      let color = colors.first(where: { $0.colors.contains(sizeToDelete) == true })!
      viewContext.delete(color)
      do {
        try viewContext.save()
      } catch {
        print("Error saving context: \(error.localizedDescription)")
      }
    }
  }

  @ViewBuilder
  private func content() -> some View {
    HFlow(itemSpacing: 10, rowSpacing: 10) {
      // 循环显示
//      let sizes = Array(Set(colors.compactMap { $0.sizeClothes }.flatMap { $0 }))

      ForEach(colors.indices, id: \.self) { colorEntiy in
        if let sizeClothes: [String]? = colors[colorEntiy].colors {
          ForEach(sizeClothes ?? [], id: \.self) { size in
            Text(size)
              .foregroundColor(.black)
              .padding()
              .frame(height: 30)
              .contentShape(Rectangle())
              .overlay(
                ZStack(alignment: .bottomTrailing) {
                  GeometryReader { geometry in
                    Color.clear
                      .preference(key: TextExWidthKey.self, value: geometry.size.width)
                  }

                  if selectedColors.contains(size) {
                    ZStack {
                      // 打勾时，出现红色圆圈
                      Circle()
                        .foregroundColor(.orange)
                        .frame(height: 10)

                      // 让image出现在红色圆圈上面
                      Image(systemName: "checkmark")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 8, height: 6)

                    }.offset(x: 0, y: 0)
                  } else {
                    //                Image(systemName: "square")
                    //                  .foregroundColor(.black)
                  }

                  //              Text(color.colors)
                  //                .foregroundColor(.black)

                  RoundedRectangle(cornerRadius: 4)

                    .strokeBorder(selectedColors.contains(size) ? Color.red : Color.black, style: StrokeStyle(lineWidth: 1))
                    .opacity(0.5)
                }
              )
              // 把选中的勾宽度随着文字宽度放在右下角

              .contentShape(Rectangle())

              .onAppear {
                // 清空选中的状态
                print("content：生命周期初始化")
                //            selectedColors.removeAll()
              }
              .onTapGesture {
                // 如果已经被选择，则从selectedColors数组中删除它；否则，将其添加到数组中
                if selectedColors.contains(size) {
                  selectedColors.removeAll(where: { $0 == size })

                  //              color.isSelected = false
                } else {
                  selectedColors.append(size)
                  //              color.isSelected = true
                }
                do {
                  try viewContext.save()
                } catch {
                  print("Error saving color: \(error.localizedDescription)")
                }
              }

              //         长按弹出提示删除框
              .onLongPressGesture {
                if let color = colors.first(where: { $0.colors.contains(size) == true }) {
                  deleteIndex = colors.firstIndex(of: color)
                  deleteAlert = true
                }
              }

              .alert(isPresented: $deleteAlert) {
                let sizeToDelete = colors[deleteIndex!].colors.first!
                return Alert(
                  title: Text("确定要删除 \(sizeToDelete) 吗？"),
                  primaryButton: .destructive(Text("删除"), action: {
                    // 调用删除操作函数来删除选定的颜色
                    deleteColor(at: deleteIndex!)
                  }),
                  secondaryButton: .cancel(Text("取消"))
                )
              }
          }
        }

        //        let isSelected = selectedColors.contains(color.colors)
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
}

// @available(iOS 16.4, *)
// struct AddView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddView()
//  }
// }

struct TextExWidthKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

// class SelectionManager: ObservableObject {
//  @Published var selectedColors: [String] = []
//
//  func reset() {
//    selectedColors = []
//  }
// }
