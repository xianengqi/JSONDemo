//
//  ContentView.swift
//  JSONDemo
//
//  Created by 夏能啟 on 2023/2/17.
//

import CoreData
import SwiftUI

struct ContentView: View {
  
  @Environment(\.managedObjectContext) private var context

  @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)], predicate: nil)
  private var tasks: FetchedResults<Task>
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(tasks) { task in
          HStack {
            Image(systemName: task.checked ? "checkmark.circle.fill" : "circle")
            Text("\(task.name!)")
            Spacer()
          }
          .contentShape(Rectangle())
          .onTapGesture {
            task.checked.toggle()
            try? context.save()
          }
        }
        .onDelete(perform: deleteTasks)
      }
      .navigationTitle("Todo")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(destination: AddTaskView()) {
            Image(systemName: "plus")
          }
        }
      }
    }
  }
  
  func deleteTasks(offsets: IndexSet) {
    for index in offsets {
      context.delete(tasks[index])
    }
    try? context.save()
  }
}

struct AddTaskView: View {
  @Environment(\.managedObjectContext) private var context
  @Environment(\.presentationMode) var presentationMode
  @State private var task = ""
  
  var body: some View {
    Form {
      Section() {
        TextField("请输入", text: $task)
      }
    }
    .navigationTitle("添加")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("保存") {
          let newTask = Task(context: context)
          newTask.timestamp = Date()
          newTask.checked = false
          newTask.name = task
          
          try? context.save()
          
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}


