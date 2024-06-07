//
//  ContentView.swift
//  DataDemo
//
//  Created by Charlie Gottlieb on 6/5/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    @State private var isFormViewActive = false
    
    @Query private var persons: [Person]
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Persons")
                
                Button(action: {
                    isFormViewActive = true
                }) {
                    Text("Go to Form View")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .navigationDestination(isPresented: $isFormViewActive) {
                    FormView(addItem: addItem)
                }
                
                List {
                    ForEach (persons) {person in
                        Text(person.firstName)
                    }
                }
            }
            .padding()
            .navigationTitle("Main View")
        }
    }
    
    func addItem(firstName: String, lastName: String, gender: String) {
        let item = Person(firstName: firstName, lastName: lastName, gender: gender)
    
        print("inserting \(firstName) \(lastName), \(gender)")
        context.insert(item)
        
    }
}

struct FormView: View {
    let addItem: (String, String, String) -> Void
    
    @State private var lastName = ""
    @State private var firstName = ""
    @State private var gender = ""
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Gender", text: $gender)
                }
            
            }
            .navigationTitle("Form")
            
            Button(action: {
                addItem(firstName, lastName, gender)
            }) {
                Text("Save")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Person.self, inMemory: true)
    }
}
