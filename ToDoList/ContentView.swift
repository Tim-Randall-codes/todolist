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
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: true )])var items: FetchedResults<Task>
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        NavigationView{
            ZStack{
                if colorScheme == .dark {
                    Background(topColour: .black, bottomColour: .red)}
                else{
                    Background(topColour: .white, bottomColour: .red)}
                VStack{
                    Text("hello world")
                    TextWidget(text: "Hello")
                }
            }
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
