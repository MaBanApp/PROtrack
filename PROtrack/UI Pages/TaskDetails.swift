//
//  TaskDetails.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TaskDetailsView: View {

    //Initalizer vars
    @State var taskID: Int = 0
    @State var projectID: Int = 0

    //Data vars
    @State private var name: String = "Lade Aufgabe..."
    @State private var desc: String = ""
    @State private var user: [UserData] = []
    @State private var guideTime: Int = 0
    @State private var bookedTime: Int = 0
    @State private var timeRecords: [TimeRecords] = []
    
    //UI Vars
    @State private var showTimeBook:Bool = false
    @State private var showingAlert = false
    @State private var alertType: String = ""
    @State private var isExpanded: Bool = false
    @State private var APIResponse: String = ""
    
    var body: some View {
        List{
            Section(header: Text("Aufgabenfortschritt")){
                ProgressView(guideTime: $guideTime, bookedTime: $bookedTime)
            }
            Section(header: Text("Beschreibung")){
                ScrollView{
                    Text(desc)
                }.frame(height:145)
            }
            Section(header: Text("Beteiligte")){
                ScrollView(.horizontal) {
                    if self.user.count == 0 {
                        Text("Noch keine Mitarbeiter hinzugefügt").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        UserCardView(ProjectMember: self.user)
                    }
                }.frame(height:86, alignment: .top)

            }
            Section(header: VStack(alignment: .leading){
                VStack(alignment: .leading) {
                    Text("Erfasste Zeiten").frame(height: 40)
                    
                    HStack {
                        Text("Datum").bold().frame(width: 120, alignment: .leading)
                        Text("Zeit").bold().frame(width: 120, alignment: .leading)
                        Text("Name").bold().frame(minWidth: 120, alignment: .leading)
                     }
                }

 
                } ) {
            if timeRecords.count == 0 {
                Text("Noch keine Zeiten verbucht").italic().foregroundColor(Color.gray)
            }
            else
            {
                ForEach (timeRecords.indices) {i in
                    VStack (alignment: .leading) {
                        HStack {
                            Text(self.timeRecords[i].date).frame(width: 120, alignment: .leading)
                            Text("\(self.timeRecords[i].time) Minuten").frame(width: 120, alignment: .leading)
                            Text("\(self.timeRecords[i].user.name)").frame(minWidth: 120, alignment: .leading)
                            
                        }
                        
                        if self.isExpanded {
                            Spacer()
                            Text("Bemerkungen").bold().frame(height: 30, alignment: .leading)
                            Text(self.timeRecords[i].description).frame(alignment: .leading)
                        }
                        
                    }.onTapGesture {
                        withAnimation(.linear(duration: 0.2)) {
                            self.isExpanded.toggle()
                        }
                }

                }.id(UUID())
            }
        }
            Section(header: Text("Aufgabe verwalten")){
                Button("Aufgabe bearbeiten"){
                print("edit pressed")
            }.foregroundColor(Color.blue)
                Button("Aufgabe abschliessen"){
                    self.alertType = "AskIfSure"
                    self.showingAlert = true
                }.foregroundColor(Color.red)
            }.listStyle(GroupedListStyle())
        }
        .alert(isPresented: $showingAlert) {
            switch alertType {
            case "AskIfSure":
                return Alert(title: Text("Aufgabe abschliessen"), message: Text("Sind Sie sicher, dass die Aufgabe abgeschlossen werden soll ?"), primaryButton: .default(Text("Ja").bold(), action: {
                    RequestService().changeStatus(projectID: self.projectID, taskID: self.taskID, newStatus: 2) {message, status in
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
                    }), secondaryButton: .default(Text("Nein")))
                
            case "Success":
                return Alert(title: Text(""), message: Text(APIResponse), dismissButton: .default(Text("OK").bold(), action:{
                    self.showingAlert.toggle()
                }))
                
            default:
                return Alert(title: Text(""), message: Text(APIResponse), dismissButton: .default(Text("OK").bold(), action:{
                    self.showingAlert.toggle()
                }))
            }
        }
        .navigationBarTitle(Text(name))
        .navigationBarItems(trailing:
            Button("Zeit erfassen") {
                self.showTimeBook = true
            }.sheet(isPresented: $showTimeBook, onDismiss: {self.updateView()}){
                TimeView(taskID: self.taskID, isPresented: self.$showTimeBook)
            }
        )
        .onAppear() {
            self.updateView()}
    }
    
    func updateView() {
        RequestService().getTaskById(taskID: self.taskID) {data in
            self.name = data.title
            self.desc = data.description
            self.user = data.users
            self.guideTime = data.guide_time
            self.bookedTime = progressService().getTotalBookedTime(timeRecords: [data])
            self.timeRecords = data.records
        }
    }
    
}
