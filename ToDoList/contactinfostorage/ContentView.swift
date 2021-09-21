//
//  ContentView.swift
//  contactinfostorage
//
//  Created by Tim Randall on 19/9/21.
//

import SwiftUI
import CoreData

struct PersonView: View {
    let name: String
    let phone: String
    let email: String
    let address: String
    var body: some View {
        VStack{
            Text("\(name)")
            Text("\(phone)")
            Text("\(email)")
            Text("\(address)")
        }
    }
}

struct AddPersonView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var enteredName: String = ""
    @State var enteredPhone: String = ""
    @State var enteredEmail: String = ""
    @State var enteredAddress: String = ""
    var body: some View {
        Text("Add New Contact")
        TextField("Enter name", text: $enteredName)
        TextField("Enter phone number", text: $enteredPhone)
        TextField("Enter email address", text: $enteredEmail)
        TextField("Enter address", text: $enteredAddress)
        Button(action:{
            let newContact = Person(context: managedObjectContext)
            newContact.name = enteredName
            newContact.phone = enteredPhone
            newContact.email = enteredEmail
            newContact.address = enteredAddress
            PersistenceController.shared.save()
        }, label: {
            Text("Add new contact")
        })
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Person.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: true )])var items: FetchedResults<Person>
    
    var body: some View {
        NavigationView{
            VStack{
            HStack{
                Spacer()
                NavigationLink(destination: AddPersonView()) {
                    Image(systemName: "person.badge.plus").resizable()
                        .frame(width: 50, height: 50)
                }
            }
                List { ForEach(items, id: \.self) { item in
                NavigationLink(destination: PersonView(name: item.name ?? "unknown", phone: item.phone ?? "unknown", email: item.email ?? "unknown", address: item.address ?? "unknown")) { Text(item.name ?? "unknown") }
                }.onDelete(perform: removeItem)
            }.navigationTitle("Contacts")
        }
    }
    
    }
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let itm = items[index]
            PersistenceController.shared.delete(itm)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
    }
}
