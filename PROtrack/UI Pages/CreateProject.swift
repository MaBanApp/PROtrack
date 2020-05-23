//
//  CreateProject.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct CreateProjectView: View {
    
    //Initalizer vars
    @State var ProjectName              : String = ""
    @State var ProjectDescription       : String = ""
    @State var selectedMembers          : [Int] = []
    @State var editProject              : Bool = false
    @State var projectID                : Int = 0

    //UI Vars
    @Binding var isPresented            : Bool
    @State private var showingAlert     : Bool = false
    @State private var APIResponse      : String = ""
    @State private var alertType        : String = ""
        
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
                        UserCardViewSelectable(SelectedMembers: $selectedMembers)
                    }
                }
            }.navigationBarTitle(self.editProject ? Text("Projekt editieren") : Text("Neues Projekt erstellen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
                Button(self.editProject ? "Aktualisieren" : "Erstellen") {
                    if self.editProject
                    {
                        RequestService().editProject(projectID: self.projectID, title: self.ProjectName, desc: self.ProjectDescription, users: self.selectedMembers) {message, status in
                            if status >= 300 {
                                self.alertType = "Error"
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                            if status <= 300 {
                                self.alertType = "Success"
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                        }
                    }
                    if !self.editProject
                    {
                        RequestService().createProject(title: self.ProjectName, desc: self.ProjectDescription, users: self.selectedMembers){ message, status in
                            if status >= 300 {
                                self.alertType = "Error"
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                            if status <= 300 {
                                self.alertType = "Success"
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                        }
                    }
                    
                })
            .listStyle(GroupedListStyle())
            }.alert(isPresented: $showingAlert) {
                switch alertType {
                case "Error":
                    return Alert(title: Text("Fehler!"), message: Text(APIResponse), dismissButton: .default(Text("OK").bold()))
                    
                case "Success":
                    return Alert(title: Text(""), message: Text(APIResponse), dismissButton: .default(Text("OK").bold(), action:{
                        self.showingAlert.toggle()
                        self.isPresented.toggle()
                    }))
                    
                default:
                    return Alert(title: Text(""), message: Text(APIResponse), dismissButton: .default(Text("OK").bold(), action:{
                        self.showingAlert.toggle()
                    }))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}
