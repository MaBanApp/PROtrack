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
    
    
    //Local vars
    @State private var Progress: Float = 0.33
    @State private var showNewTask: Bool = false
    @State private var showingAlert = false

    
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
                
                if self.tasks?.count == 0 {
                    Text("Noch keine Aufgaben hinzugefügt").italic().foregroundColor(Color.gray)
                }
                else
                {
                    ForEach (0 ..< self.tasks!.count) {i in
                        NavigationLink(destination: TaskDetailsView(name: self.tasks![i].title,
                                                                    desc: self.tasks![i].description,
                                                                    guideTime: self.tasks![i].guide_time,
                                                                    timeRecords: self.tasks![i].records)){
                            Text(self.tasks![i].title)
                        }
                    }
                }
                        
            }
            
            Section(header: Text("Projekt verwalten")){
             
                Button("Projekt bearbeiten"){
                    print("edit pressed")
                }.foregroundColor(Color.blue)
                Button("Projekt abschliessen"){
                    self.showingAlert = true
                }.foregroundColor(Color.red).alert(isPresented: $showingAlert) {
                    Alert(title: Text("Projekt abschliessen"), message: Text("Sind Sie sicher, dass das Projekt abgeschlossen werden soll ?"), primaryButton: .default(Text("Ja").bold(), action: {
                                print("Confirmed")
                        }), secondaryButton: .default(Text("Nein")))}
                
            }.listStyle(GroupedListStyle())
            
        }.navigationBarTitle(name)
        .navigationBarItems(trailing:
            Button("Neue Aufgabe") {
                self.showNewTask = true
            }.sheet(isPresented: $showNewTask){
                CreateTaskView(isPresented: self.$showNewTask)
            }
        )
    }
}

struct ProjectDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        ProjectDetailsView()
    }
}
