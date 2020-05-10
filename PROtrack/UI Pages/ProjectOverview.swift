//
//  ProjectOverview.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct ProjectOverviewView: View {
    
    @State var showNewProject: Bool = false
    
    @Binding var isPresented: Bool

    var body: some View {

        NavigationView {
            
            List{
                Section(header: Text("Laufende Projekte"))
                {
                    HStack {
                        NavigationLink(destination: ProjectDetailsView(ProjectId: "Projekt 1")){
                            Text("Projekt 1")
                        }
                    }
                    HStack {
                        NavigationLink(destination: ProjectDetailsView(ProjectId: "Projekt 2")){
                            Text("Projekt 2")
                        }
                    }
                    HStack {
                        NavigationLink(destination: ProjectDetailsView(ProjectId: "Projekt 3")){
                            Text("Projekt 3")
                        }
                    }
                }
                
                Section(header: Text("Abgeschlossene Projekte")){
                    Text("Noch keine abgeschlossenen Projekte").italic().foregroundColor(Color.gray)
                }

            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Projekte"))
            .navigationBarItems(
                leading:
                    Button("Abmelden") { self.isPresented = false
                }
                ,trailing:
                    Button("Neues Projekt") {
                        self.showNewProject = true
                    }.sheet(isPresented: $showNewProject){
                        CreateProjectView(isPresented: self.$showNewProject)
                    }
            )

        }
    }

}

