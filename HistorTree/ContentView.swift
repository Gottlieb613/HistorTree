//
//  ContentView.swift
//  HistorTree
//
//  Created by Charlie Gottlieb on 6/3/24.
//

import SwiftUI


struct ContentView: View {
    @State private var isShowingInsertForm = false
    @StateObject private var personsDatabaseManager = PersonsDatabaseManager()
    
    var body: some View {
        Text("HistorTree").font(.system(size: 50))
        
        VStack {
            Button("Insert Person") {
                isShowingInsertForm.toggle()
            }
            Button("Query Users") {
                personsDatabaseManager.queryUsers()
            }
        }
        .sheet(isPresented: $isShowingInsertForm) {
            InsertFormView(personsDatabaseManager: personsDatabaseManager, isPresented: true, firstName: "", lastName: "", selectedGender: true, birthYear: "1970")
            
        }
    }
}

struct InsertFormView: View {
    @StateObject var personsDatabaseManager: PersonsDatabaseManager
    @Environment(\.presentationMode) var presentationMode

    
    @State var isPresented: Bool
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var selectedGender: Bool = false
    @State var birthYear: String = "1970"


    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Gender")) {
                    Picker("Gender", selection: $selectedGender) {
                        Text("Male").tag(true)
                        Text("Female").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Birth Year")) {
                    HStack {
                        Spacer()
                        TextField("Year", text: $birthYear)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .padding(.vertical)
                        Spacer()
                    }
                    .padding(.horizontal)
                }

                Section {
                    Button("Save") {
                        // Perform insertion operation with provided data
                        // For example: personsDatabaseManager.insertUser(name_first: firstName, name_last: lastName, gender: selectedGender.rawValue)
                        
                        let year = Int64(birthYear) ?? 1970 // Convert int to Int64
                        
                        personsDatabaseManager.insertUser(name_first: firstName, name_last: lastName, gender: selectedGender, birth_year: year)
                        
                        // Close the modal view
                        isPresented = false
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }
            }
            .navigationTitle("Insert Person")
            .navigationBarItems(trailing: Button("Cancel") {
                // Close the modal view without saving
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

//
//
//enum Emoji: String, CaseIterable {
//    case 👍,😃,👻,🫥
//}
//
//struct ContentView: View {
//    @State var selection: Emoji = .😃
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text(selection.rawValue)
//                    .font(.system(size: 150))
//                
//                Picker("Select Emoji: ", selection: $selection) {
//                    ForEach(Emoji.allCases, id: \.self) {
//                        emoji in Text(emoji.rawValue)
//                    }
//                }
//                .pickerStyle(.navigationLink)
//            }
//            .navigationTitle("Emoji Testing")
//            .padding()
//        }
//    }
//}

#Preview {
    ContentView()
}
