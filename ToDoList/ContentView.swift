//
//  ContentView.swift
//  ToDoList
//
//  Created by Tim Randall on 21/9/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: true )],
        predicate: NSPredicate(format: "completed = %d", false))var items: FetchedResults<Task>
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        NavigationView{
            ZStack{
                if colorScheme == .dark {
                    Background(topColour: .black, bottomColour: .red)}
                else{
                    Background(topColour: .white, bottomColour: .red)}
                VStack{
                    Spacer()
                    HStack{
                        NavigationLink(destination: AddTaskView()){
                            Image(systemName: "plus").resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                    List { ForEach(items, id: \.self) { item in
                        Button(action: {
                            item.completed = true
                        }, label: {
                            TextWidget(text: item.words ?? "unknown")
                       })
                        }
                    }
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
                Background(topColour: .black, bottomColour: .red)}
            else{
                Background(topColour: .white, bottomColour: .red)}
        VStack {
            TextWidget(text: "You add tasks here").padding()
            TextField("Type in your task and press add", text: $taskEntry).padding()
            Button(action: {
                let newTask = Task(context: managedObjectContext)
                newTask.completed = false
                newTask.date = Date()
                newTask.words = taskEntry
                PersistenceController.shared.save()
            }, label: {
                TextWidget(text: "Add task").padding()
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            })
        }.navigationTitle("Add Task")
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
