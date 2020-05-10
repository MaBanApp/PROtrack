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
    @State var projData:ProjectResponse?
    @State var ready: Bool = false

        
    @Binding var isPresented: Bool

    var body: some View {

        
        NavigationView {
            List{
                Section(header: Text("Laufende Projekte")){
                    if !ready {
                        Text("Lade Projekte...").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        ForEach(0 ..< self.projData!.payload.count) {i in
                                                        
                            if self.projData!.payload[i].status == 0 {
                                NavigationLink(destination: ProjectDetailsView(name: self.projData!.payload[i].name,
                                                                               desc: self.projData!.payload[i].description,
                                                                               user: self.projData!.payload[i].users,
                                                                               tasks: self.projData!.payload[i].tasks)){
                                    Text(self.projData!.payload[i].name)
                                }
                            }
                            
                        }
                    }

                }
                
                Section(header: Text("Abgeschlossene Projekte")){
                    if !ready {
                        Text("Lade Projekte...").italic().foregroundColor(Color.gray)
                    }
                    else
                    {
                        ForEach(0 ..< self.projData!.payload.count) {i in
                            if self.projData?.payload[i].status == 1 {
                                NavigationLink(destination: ProjectDetailsView()) {
                                   Text(self.projData!.payload[i].name)
                                }
                            }
                            else
                            {
                                Text("Noch keine abgeschlossenen Projekte").italic().foregroundColor(Color.gray)
                            }
                        }
                    }
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

        }.onAppear(){
            AppDelegate().dbhandler.getProjects() {result in
                self.projData = result
                self.ready.toggle()
            }
        }

    }

}

