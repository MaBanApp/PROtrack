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
                Button("Erstellen") { print(AppDelegate().dbhandler.getSelectedUser(firstName: self.ProjectMemberFirstName, lastName: self.ProjectMemberLastName, selected: self.selectedMembers))}
            )
            .listStyle(GroupedListStyle())


            }.navigationViewStyle(StackNavigationViewStyle())

    }
}
