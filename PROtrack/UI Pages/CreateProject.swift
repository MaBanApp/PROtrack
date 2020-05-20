//
//  CreateProject.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct CreateProjectView: View {
    
    @State var ProjectName:String = ""
    @State var ProjectDescription:String = ""
    @State var selectedMembers:[Int] = []
    
    @State var ProjectMemberFirstName: [String] = ["Marino", "Robin", "Vladislav"]
    @State var ProjectMemberLastName: [String] = ["Bantli", "Portner", "Juhasz"]
    
    @Binding var isPresented: Bool
    @State private var showingAlert: Bool = false
    @State private var APIResponse: String = ""
        
    var body: some View {
        
        NavigationView {
            
            List{
                Section(header: Text("Projektname")){
                    TextField("Projektname", text: $ProjectName)
                }
                
                Section(header: Text("Projektbeschreibung")) {
                    ScrollView {
                        TextField("Projektbeschreibung", text: $ProjectDescription)
                    }.frame(height:120)
                }
                
                Section(header: Text("Mitglieder")) {
                    ScrollView(.horizontal, showsIndicators: false){
                        UserCardViewSelectable(SelectedMembers: $selectedMembers, ProjectMember: ["Marino Bantli", "Vladislav Juhasz", "Robin Portner"])
                    }
                }


            }.navigationBarTitle(Text("Neues Projekt erstellen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
                Button("Erstellen") {
                    RequestService().createProject(title: self.ProjectName, desc: self.ProjectDescription){ message, status in
                            if status >= 300 {
                                self.APIResponse = message
                            }
                            if status <= 300 {
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                        }
                })
            .listStyle(GroupedListStyle())


            }.alert(isPresented: self.$showingAlert) {
                Alert(title: Text("Projekt erstellt"), message: Text(self.APIResponse), dismissButton: .default(Text("OK").bold(), action: {
                    self.isPresented.toggle()
            }))}
            .navigationViewStyle(StackNavigationViewStyle())

    }
}
