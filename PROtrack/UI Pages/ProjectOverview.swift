//
//  ProjectOverview.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct ProjectOverviewView: View {
    
    //Initalizer vars
    @State var userID                   : Int
    @State var projData                 : ProjectResponse?
    @Binding var isPresented            : Bool

    //UI vars
    @State private var showNewProject   : Bool = false
    @State private var ready            : Bool = false
    @State private var NavBarTitle      : String = "Projekte"

    var body: some View {

        NavigationView {
            List{
                Section(header: Text("Laufende Projekte")){
                    if projData!.payload.count == 0{
                        Text("Noch keine Projekte").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        ForEach (projData!.payload.indices) {i in
                            if self.projData!.payload[i].status == 1 {
                                NavigationLink(destination: ProjectDetailsView(projectID: self.projData!.payload[i].id, payloadID: i)){
                                    Text(self.projData!.payload[i].name)
                                }
                            }
                        }.id(UUID())
                    }
                }
                Section(header: Text("Abgeschlossene Projekte")){
                    if projData!.payload.count == 0{
                        Text("Noch keine abgeschlossenen Projekte").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        ForEach (projData!.payload.indices) {i in
                            if self.projData!.payload[i].status == 2 {
                                NavigationLink(destination: ProjectDetailsView(projectID: self.projData!.payload[i].id, payloadID: i)){
                                    Text(self.projData!.payload[i].name)
                                }
                            }
                        }.id(UUID())
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text(NavBarTitle))
            .navigationBarItems(
                leading:
                    Button("Abmelden") { self.isPresented = false
                }
                ,trailing:
                    Button("Neues Projekt") {
                        self.showNewProject = true
                    }.sheet(isPresented: $showNewProject, onDismiss: {self.updateView()}){
                        CreateProjectView(isPresented: self.$showNewProject)
                    })
        }
        .onAppear(){
            self.updateView()
    }
    }
    
    func updateView() {
        RequestService().getProjects() {data in
            self.projData = data
        }
    }
    
}
