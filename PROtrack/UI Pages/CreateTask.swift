//
//  CreateTask.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct CreateTaskView: View {
    
    //Initalizer vars
    @State var TaskID                   : Int = 0
    @State var projectID                : Int = 0
    @State var TaskName                 : String = ""
    @State var TaskDescription          : String = ""
    @State var GuideTime                : String = ""
    @State var editTask                 : Bool = false
    @State var selectedMembers          : [Int] = []
    @State var userData                 : [UserData] = []
        
    //UI Vars
    @Binding var isPresented            : Bool
    @State private var showingAlert     : Bool = false
    @State private var APIResponse      : String = ""
    @State private var alertType        : String = ""

    
    var body: some View {     
        NavigationView {
            List {
                Section(header: Text("Aufgabenname")){
                    TextField("Aufgabentitel", text: $TaskName)
                }
                Section(header: Text("Beschreibung")) {
                    ScrollView {
                        TextField("", text: $TaskDescription)
                    }.frame(height:120)
                }
                Section(header: Text("Richtzeit")) {
                    HStack {
                        TextField("Zeit", text: $GuideTime).keyboardType(.numberPad)
                        Spacer()
                        Text("Minuten")
                    }
                }
                Section(header: Text("Mitglieder")) {
                    ScrollView(.horizontal, showsIndicators: false){
                        UserCardViewSelectable(SelectedMembers: $selectedMembers, projectID: self.projectID)
                    }
                }
            }.navigationBarTitle(self.editTask ? Text("Aufgabe editieren") : Text("Neue Aufgabe erstellen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
               Button(self.editTask ? "Aktualisieren" : "Erstellen") {
                if self.editTask {
                    RequestService().editTask(taskID: self.TaskID, title: self.TaskName, desc: self.TaskDescription, guideTime: Int(self.GuideTime) ?? 0) { message, status in
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
                if !self.editTask {
                    RequestService().createTask(projectID: self.projectID,
                                                title: self.TaskName,
                                                desc: self.TaskDescription,
                                                guideTime: self.GuideTime,
                                                Users: self.selectedMembers) { message, status in
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
