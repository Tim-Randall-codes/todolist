//
//  ContentView.swift
//  ToDoList
//
//  Created by Tim Randall on 21/9/21.
//

import SwiftUI
import CoreData
import Foundation //imported this to change dates to strings

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: true )],
        predicate: NSPredicate(format: "completed = %d", false))var items: FetchedResults<Task>
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    init(){
            UITableView.appearance().backgroundColor = .clear
        }
    var body: some View {
        NavigationView{
            ZStack{
                if colorScheme == .dark {
                    Background(topColour: .black, bottomColour: .blue)}
                else{
                    Background(topColour: .white, bottomColour: .blue)}
                VStack{
                    Spacer()
                    HStack{
                        NavigationLink(destination: CompletedTaskView()){
                            TextWidget(text: "View Completed Tasks").padding()
                        }
                        Spacer()
                        NavigationLink(destination: AddTaskView()){
                            Image(systemName: "plus").resizable()
                                .frame(width: 50, height: 50).padding()
                        }
                    }
                    List { ForEach(items, id: \.self) { item in
                        Button(action: {
                            item.completed = true
                            PersistenceController.shared.save()
                        }, label: {
                            TextWidget(text: item.words ?? "unknown")
                       })
                        }
                    }.navigationTitle("To Do")
                }
            }
        }
    }
}

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var taskEntry: String = ""
    var body: some View {
        ZStack{
            if colorScheme == .dark {
                Background(topColour: .black, bottomColour: .blue)}
            else{
                Background(topColour: .white, bottomColour: .blue)}
        VStack {
            TextWidget(text: "Add your tasks here").padding()
            TextField("Type in your task and press Add Task", text: $taskEntry).padding()
            Button(action: {
                let newTask = Task(context: managedObjectContext)
                newTask.completed = false
                newTask.date = Date()
                newTask.words = taskEntry
                PersistenceController.shared.save()
                taskEntry = ""
            }, label: {
                TextWidget(text: "Add Task").padding()
                    .border(Color.blue, width: 3).cornerRadius(8)
            })
        }.navigationTitle("Add Task")
        }
    }
}

struct CompletedTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: true )],
        predicate: NSPredicate(format: "completed = %d", true))var items: FetchedResults<Task>
    let dateFormatter = DateFormatter()
    var body: some View {
        NavigationView {
            ZStack{
                if colorScheme == .dark {
                    Background(topColour: .black, bottomColour: .blue)}
                else{
                    Background(topColour: .white, bottomColour: .blue)}
                List { ForEach(items, id: \.self) { item in
                    let dateStringHere = getDate(x: item.date!)
                    TextWidget(text: "\(dateStringHere), \(item.words ?? "unknown task")")
                    }.onDelete(perform: removeItem)
                }
            }
        }.navigationTitle("Completed Tasks")
    }
    func getDate(x: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        let dateString = dateFormatter.string(from: x)
        return dateString
    }
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let itm = items[index]
            PersistenceController.shared.delete(itm)
            }
        }
}

struct Background: View {
    var topColour: Color
    var bottomColour: Color
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [topColour, bottomColour]),
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}

struct TextWidget: View {
    var text: String
    var body: some View {
        Text(text).font(Font.system(size: 24))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
    }
}
