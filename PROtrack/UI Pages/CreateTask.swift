//
//  CreateTask.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct CreateTaskView: View {
    
    @State var TaskName:String = ""
    @State var TaskDescription:String = ""
    @State var GuideTime: String = ""
    
    @State var selectedMembers:[Int] = []
    @State var ProjectMemberFirstName: [String] = ["Marino", "Robin", "Vladislav"]
    @State var ProjectMemberLastName: [String] = ["Bantli", "Portner", "Juhasz"]
    
    @Binding var isPresented: Bool

    
    var body: some View {
        
        NavigationView {
            
            List {
                Section(header: Text("Aufgabenname")){
                    TextField("Aufgabentitel", text: $TaskName)
                }
            
                Section(header: Text("Beschreibung")) {
                    ScrollView {
                        TextField("Beschreibung", text: $TaskDescription)
                    }.frame(height:120)
                }
                
                Section(header: Text("Richtzeit")) {
                    HStack {
                        TextField("Zeit", text: $GuideTime).keyboardType(.numberPad)
                        Spacer()
                        Text("Stunden")
                    }
                }
                
                Section(header: Text("Mitglieder")) {
                    ScrollView(.horizontal, showsIndicators: false){
                        UserCardView(SelectedMembers: $selectedMembers, ProjectMemberFirstName: ["Marino", "Robin", "Vladislav"], ProjectMemberLastName: ["Bantli", "Portner", "Juhasz"])
                    }
                }
                
            }.navigationBarTitle(Text("Neue Aufgabe erstellen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
               Button("Erstellen") { print(AppDelegate().dbhandler.getSelectedUser(firstName: self.ProjectMemberFirstName, lastName: self.ProjectMemberLastName, selected: self.selectedMembers))}
            )
            .listStyle(GroupedListStyle())
            
        }.navigationViewStyle(StackNavigationViewStyle())

    }
}
