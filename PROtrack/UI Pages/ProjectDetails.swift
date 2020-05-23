//
//  ProjectDetails.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct ProjectDetailsView: View {

    //Initalizer vars
    @State var projectID                : Int
    @State var payloadID                : Int
    @State var isFinished               : Bool
    
    //Data vars
    @State private var name             : String = "Lade Projekt..."
    @State private var desc             : String = ""
    @State private var user             : [UserData]?
    @State private var tasks            : [TaskPayload]?
    @State private var guideTime        : Int = 0
    @State private var bookedTime       : Int = 0

    //UI vars
    @State private var ready            : Bool = false
    @State private var showNewTask      : Bool = false
    @State private var showEditProject  : Bool = false
    @State private var showingAlert     : Bool = false
    @State private var alertType        : String = ""
    @State private var APIResponse      : String = ""
    
    var body: some View {
        List{
            Section(header: Text("Projektfortschritt")){
                ProgressView(guideTime: $guideTime, bookedTime: $bookedTime)
            }
            Section(header: Text("Beschreibung")){
                if ready {
                    ScrollView{
                        Text(desc)
                    }.frame(height:145)
                }
                else
                {
                    ScrollView {
                        Text("Wird geladen...").italic().foregroundColor(Color.gray)
                    }.frame(height:145)
                }

            }
            Section(header: Text("Beteiligte")){
                if ready {
                    ScrollView(.horizontal) {
                        if self.user!.count == 0 {
                            Text("Noch keine Mitarbeiter hinzugefügt").italic().foregroundColor(Color.gray)
                        }
                        else
                        {
                            UserCardView(ProjectMember: self.user!)
                        }
                    }.frame(height:86, alignment: .top)
                }
                else
                {
                    Text("Wird geladen...").italic().foregroundColor(Color.gray).frame(height: 86)
                }
            }
            Section(header: Text("Projektaufgaben")){
                if ready {
                    if tasks?.count == 0{
                        Text("Noch keine Aufgaben hinzugefügt").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        ForEach (tasks!.indices) {i in
                            if self.tasks![i].status == 1 {
                                NavigationLink(destination: TaskDetailsView(taskID: self.tasks![i].id,
                                                                            projectID: self.projectID,
                                                                            isFinished: false)){
                                Text(self.tasks![i].title)}
                            }
                            else
                            {
                                NavigationLink(destination: TaskDetailsView(taskID: self.tasks![i].id,
                                                                            projectID: self.projectID,
                                                                            isFinished: true)){
                                    HStack {
                                        Text(self.tasks![i].title).italic()
                                        Spacer()
                                        Text("Abgeschlossen").italic().foregroundColor(Color.gray)
                                    }
                                }
                            }
                        }.id(UUID())
                    }
                }
            }
            if !isFinished {
                Section(header: Text("Projekt verwalten")){
                    Button("Projekt bearbeiten"){
                        self.showEditProject.toggle()
                    }.foregroundColor(Color.blue).sheet(isPresented: $showEditProject, onDismiss: {self.updateView()}) {
                        CreateProjectView(ProjectName: self.name,
                                          ProjectDescription: self.desc,
                                          editProject: true,
                                          projectID: self.projectID,
                                          isPresented: self.$showEditProject)
                    }
                    Button("Projekt abschliessen"){
                        self.showingAlert.toggle()
                        self.alertType = "AskIfSure"
                        
                    }.foregroundColor(Color.red)
                }
            }
        }.listStyle(GroupedListStyle())
        .alert(isPresented: $showingAlert) {
        switch alertType {
            
        case "AskIfSure":
            return Alert(title: Text("Projekt abschliessen"),
                    message: Text("Sind Sie sicher, dass das Projekt abgeschlossen werden soll ?"),
                    primaryButton: .default(Text("Ja").bold(), action: {
                    
                        RequestService().changeStatus(projectID: self.projectID, taskID: 0, newStatus: 2) { message, status in
                            self.APIResponse = message
                            
                            if status <= 300 {
                            self.alertType = "Success"
                            self.showingAlert = true
                            }
                            else
                            {
                            self.alertType = ""
                            self.showingAlert = true
                            }
                            
                        }
                    }),
                    secondaryButton: .default(Text("Nein")))
            
        case "Success":
            return Alert(title: Text(""), message: Text(APIResponse), dismissButton: .default(Text("OK").bold(), action: {
                self.showingAlert.toggle()
                }))
            
        default:
            return Alert(title: Text(""), message: Text(APIResponse), dismissButton: .default(Text("OK").bold(), action: {
                self.showingAlert.toggle()
                }))
        }
    }
        .navigationBarTitle(Text(name), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(self.isFinished ? "" : "Neue Aufgabe") {
                self.showNewTask = true
            }.sheet(isPresented: $showNewTask, onDismiss: {self.updateView()}){
                CreateTaskView(projectID: self.projectID, isPresented: self.$showNewTask)
        })
        .onAppear() {
            self.updateView()}
    }

}

//View-dependend functions
extension ProjectDetailsView {
    
    func updateView() {
        RequestService().getProjects() { data in
            self.name = data.payload[self.payloadID].name
            self.desc = data.payload[self.payloadID].description
            self.user = data.payload[self.payloadID].users
            self.tasks = data.payload[self.payloadID].tasks
            self.guideTime = progressService().getTotalGuideTime(timeRecords: data.payload[self.payloadID].tasks)
            self.bookedTime = progressService().getTotalBookedTime(timeRecords: data.payload[self.payloadID].tasks)
            self.ready = true
        }
    }

}
