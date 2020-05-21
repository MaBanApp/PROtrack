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
    @State var name: String = ""
    @State var desc: String = ""
    @State var user: [UserData]?
    @State var tasks:[TaskPayload]?
    @State var projectID: Int = 0
    @State var payloadID: Int = 0
    
    
    //Local vars
    @State private var Progress: Float = 0.33
    @State private var showNewTask: Bool = false
    @State private var showingAlert = false
    @State private var alertType: String = ""
    @State private var APIResponse: String = ""
    
    var body: some View {
        
        List{
            Section(header: Text("Projektfortschritt")){
                VStack{
                    HStack{
                        Text("Richtzeit:")
                        Spacer()
                        Text("\(progressService().getTotalGuideTime(timeRecords: self.tasks!)) Minuten")
                    }
                    HStack {
                        Text("Verbuchte Zeit:")
                        Spacer()
                        Text("\(progressService().getTotalBookedTime(timeRecords: self.tasks!)) Minuten")
                    }
                    ProgressBar(value: $Progress).frame(height:10)
                }.frame(height: 70)
                .onAppear() {
                    let totalGuideTime:Int = Int(progressService().getTotalGuideTime(timeRecords: self.tasks!))!
                    let totalBookedTime: Int = Int(progressService().getTotalBookedTime(timeRecords: self.tasks!))!
                    if totalGuideTime >= 1 {
                        self.Progress = Float(totalBookedTime) / Float(totalGuideTime)
                    }
                    else
                    {
                        self.Progress = 0
                    }
                }
            }
            Section(header: Text("Beschreibung")){
                ScrollView{
                    Text(desc)
                }.frame(height:145)
            }
            Section(header: Text("Beteiligte")){
                ScrollView(.horizontal) {
                    if self.user!.count == 0 {
                        Text("Noch keine Mitarbeiter hinzugefügt").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        //UserCardView
                    }
                }.frame(height:86, alignment: .top)

            }
            Section(header: Text("Projektaufgaben")){
                
                if tasks?.count == 0{
                    Text("Noch keine Aufgaben hinzugefügt").italic().foregroundColor(Color.gray)
                }
                else
                {
                    ForEach (tasks!.indices) {i in
                        if self.tasks![i].status == 1 {
                            NavigationLink(destination: TaskDetailsView(name: self.tasks![i].title,
                                                                        desc: self.tasks![i].description,
                                                                        guideTime: self.tasks![i].guide_time,
                                                                        taskID: self.tasks![i].id,
                                                                        projectID: self.projectID)){
                            Text(self.tasks![i].title)}
                        }
                        else
                        {
                            NavigationLink(destination: TaskDetailsView(name: self.tasks![i].title,
                                                                            desc: self.tasks![i].description,
                                                                            guideTime: self.tasks![i].guide_time,
                                                                            taskID: self.tasks![i].id,
                                                                            projectID: self.projectID)){
                            Text(self.tasks![i].title).italic().strikethrough().foregroundColor(Color.gray)}
                        }
                    }.id(UUID())
                }
            }
            Section(header: Text("Projekt verwalten")){
                Button("Projekt bearbeiten"){
                    print("edit pressed")
                }.foregroundColor(Color.blue)
                Button("Projekt abschliessen"){
                    self.showingAlert.toggle()
                    self.alertType = "AskIfSure"
                    
                }.foregroundColor(Color.red)
            }.listStyle(GroupedListStyle())
        }.alert(isPresented: $showingAlert) {
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
        .navigationBarTitle(name)
        .navigationBarItems(trailing:
            Button("Neue Aufgabe") {
                self.showNewTask = true
            }.sheet(isPresented: $showNewTask, onDismiss: {self.updateView()}){
                CreateTaskView(projectID: self.projectID, isPresented: self.$showNewTask)
        })
        .onAppear() {self.updateView()}
    }
    
    func updateView() {
        RequestService().getProjects() { data in
            self.tasks = data.payload[self.payloadID].tasks
        }
    }

}

struct ProjectDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        ProjectDetailsView()
    }
}
