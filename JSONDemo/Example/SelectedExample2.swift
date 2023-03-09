import SwiftUI

//
// 现在，我们已经完成了我们的SwiftUI代码块，可以在需要的地方使用它来实现服装库存管理的功能。完整的代码如下所示：
//
// ```swift

struct InventoryView: View {
  let clothesColor = ["红色", "橘红", "卡其"]
  let clothesSize = ["S", "M", "L"]

  @State private var selectedColor: String?
  @State private var selectedSize: String?
  @State private var quantityToAdd = 0
  @State private var inventory: [String: [String: Int]]

  init() {
    var tempInventory = [String: [String: Int]]()
    for color in clothesColor {
      var sizes = [String: Int]()
      for size in clothesSize {
        sizes[size] = Int.random(in: 1 ... 10)
      }
      tempInventory[color] = sizes
    }
    self._inventory = State(initialValue: tempInventory)
  }

  var body: some View {
    VStack {
      Text("服装库存")
        .font(.largeTitle)
        .padding()
      if let selectedColor = selectedColor {
        Text(selectedColor)
          .font(.headline)
          .padding(.top)
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
          ForEach(clothesSize, id: \.self) { size in
            Text(size)
              .foregroundColor(size == selectedSize ? .blue : .black)
              .frame(maxWidth: .infinity, minHeight: 50)
              .background(size == selectedSize ? Color.yellow : Color.clear)
              .onTapGesture {
                selectedSize = size
              }
            if let inventoryCount = inventory[selectedColor]?[size] {
              Text("\(inventoryCount)")
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(size == selectedSize ? Color.yellow : Color.clear)
            }
          }
        }
      } else {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
          ForEach(clothesColor, id: \.self) { color in
            Text(color)
              .foregroundColor(color == selectedColor ? .blue : .black)
              .frame(maxWidth: .infinity, minHeight: 50)
              .background(color == selectedColor ? Color.yellow : Color.clear)
              .onTapGesture {
                selectedColor = color
                selectedSize = nil
              }
          }
        }
      }
      if let selectedColor = selectedColor, let selectedSize = selectedSize {
        Text("库存数量: \(inventory[selectedColor]![selectedSize]!)")
        Stepper("添加 \(quantityToAdd) 件", value: $quantityToAdd)
        Button("入库") {
          inventory[selectedColor]![selectedSize]! += quantityToAdd
          quantityToAdd = 0
        }
      }
      Button("出库") {
        if let selectedColor = selectedColor, let selectedSize = selectedSize {
          inventory[selectedColor]![selectedSize]! -= 1
        }
      }
      Spacer()
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }
}

struct ColorViewsss: View {
  let color: String
  let isSelected: Bool
  let onSelect: () -> Void
  let sizes: [String]
  let selectedSize: String?
  let onSelectSize: (String) -> Void

  var body: some View {
    VStack {
      HStack {
        Text(color)
          .font(.headline)
          .foregroundColor(isSelected ? .blue : .black)
          .frame(width: 100)
          .onTapGesture {
            onSelect()
          }
        Spacer()
      }
      ForEach(sizes, id: \.self) { size in
        if size == selectedSize || selectedSize == nil {
          Text(size)
            .foregroundColor(size == selectedSize ? .blue : .black)
            .frame(width: 50)
            .onTapGesture {
              onSelectSize(size)
            }
        }
      }
    }
  }
}

struct ClothesView_Previews: PreviewProvider {
  static var previews: some View {
    InventoryView()
  }
}
