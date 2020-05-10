//
//  TaskOverview.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TaskOverviewView: View {
                
    @Binding var isPresented: Bool

        var body: some View {

            NavigationView {
                
                List{
                    
                    Section(header: Text("Offene Aufgaben")) {
                        HStack {
                            NavigationLink(destination: TaskDetailsView(ProjectId: "Aufgabe 2", Progress: 0.33)){
                            
                                HStack {
                                    VStack(alignment: .leading){
                                        Text("Projekt 1").font(.system(size: 12))
                                        Spacer()
                                        Text("Aufgabe 2").bold().font(.system(size: 15))
                                        Spacer()
                                        Text("Verbuchte Zeit 60 / 180 Minuten").font(.system(size: 14))
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Fertigstellen bis:").font(.system(size: 12))
                                        Text("16.06.2020").font(.system(size: 14))
                                        Spacer()
                                    }
                                }

                            }
                        }
                        
                        HStack {
                            NavigationLink(destination: TaskDetailsView(ProjectId: "Aufgabe 4", Progress: 0)){
                            
                                HStack {
                                    VStack(alignment: .leading){
                                        Text("Projekt 1").font(.system(size: 12))
                                        Spacer()
                                        Text("Aufgabe 4").bold().font(.system(size: 15))
                                        Spacer()
                                        Text("Verbuchte Zeit 0 / 180 Minuten").font(.system(size: 14))
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Fertigstellen bis:").font(.system(size: 12))
                                        Text("05.08.2020").font(.system(size: 14))
                                        Spacer()
                                    }
                                }

                            }
                        }
                            
                        HStack {
                            NavigationLink(destination: TaskDetailsView(ProjectId: "Aufgabe 1", Progress: 0.7)){
                            
                                HStack {
                                    VStack(alignment: .leading){
                                        Text("Projekt 2").font(.system(size: 12))
                                        Spacer()
                                        Text("Aufgabe 1").bold().font(.system(size: 15))
                                        Spacer()
                                        Text("Verbuchte Zeit 140 / 180 Minuten").font(.system(size: 14))
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Fertigstellen bis:").font(.system(size: 12))
                                        Text("28.05.2020").font(.system(size: 14))
                                        Spacer()
                                    }
                                }
                            }

                        }
                    }
                    Section(header: Text("Abgeschlossene Aufgaben")) {
                        Text("Noch keine abgeschlossenen Aufgaben").italic().foregroundColor(Color.gray)
                    }

                }.listStyle(GroupedListStyle())
                    
            .navigationBarTitle(Text("Meine Aufgaben"))
            .navigationBarItems(leading:
            Button("Abmelden") { self.isPresented = false})
        }

    }
    
}
