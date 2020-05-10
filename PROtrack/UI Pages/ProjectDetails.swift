//
//  ProjectDetails.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct ProjectDetailsView: View {


    @State var name: String = ""
    @State var desc: String = ""
    @State var user: [String] = []
    @State var tasks:[TaskData]?
    
    @State var Progress: Float = 0.33
    
    @State var showNewTask: Bool = false
    @State var showingAlert = false

    
    var body: some View {
        
        List{
            Section(header: Text("Projektfortschritt")){
                VStack{
                    HStack{
                        Text("Richtzeit:")
                        Spacer()
                        Text("180 Minuten")
                    }
                    HStack {
                        Text("Verbuchte Zeit:")
                        Spacer()
                        Text("60 Minuten")
                    }
                    ProgressBar(value: $Progress).frame(height:10)
                }.frame(height: 70)
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
                        UserCardView(ProjectMember: user)
                    }
                }.frame(height:86, alignment: .top)

            }
            Section(header: Text("Projektaufgaben")){
                
                if self.tasks!.count == 0 {
                    Text("Noch keine Aufgaben hinzugefügt").italic().foregroundColor(Color.gray)
                }
                else
                {
                    ForEach (0 ..< self.tasks!.count) {i in
                        if self.tasks![i].status == 1 {
                            NavigationLink(destination: TaskDetailsView(name: self.tasks![i].title,
                                                                        desc: self.tasks![i].description,
                                                                        user: self.tasks![i].users,
                                                                        guideTime: self.tasks![i].guideTime,
                                                                        timeRecords: self.tasks![i].timeRecords) ){
                                Text(self.tasks![i].title)
                            }
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
