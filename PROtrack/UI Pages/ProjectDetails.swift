//
//  ProjectDetails.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct ProjectDetailsView: View {
    
    
    @State public var ProjectId: String = "Projekt"
    @State var Progress:Float = 0.33
    
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
                        Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
                    }.frame(height:145)
                }
                Section(header: Text("Beteiligte")){
                    
                    ScrollView(.horizontal) {
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                                Text("Marino").font(.system(size: 12))
                                Text("Bantli").font(.system(size: 12))

                            }.frame(width: 60, height: 85).background(Color("LightGray")).cornerRadius(5)
                            
                            VStack{
                                Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                                Text("Robin").font(.system(size: 12))
                                Text("Portner").font(.system(size: 12))
                                
                            }.frame(width: 60, height: 85).background(Color("LightGray")).cornerRadius(5)
                            
                            VStack{
                                Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                                Text("Vladislav").font(.system(size: 12))
                                Text("Juhasz").font(.system(size: 12))
                            }.frame(width: 60, height: 85).background(Color("LightGray")).cornerRadius(5)
                            
                            Spacer()
                        }.frame(height:86, alignment: .top)
                    }

                }
                Section(header: Text("Projektaufgaben")){
                    
                    NavigationLink(destination: TaskDetailsView(ProjectId: "Aufgabe 1", Progress: 1)){
                        Text("Aufgabe 1").strikethrough().foregroundColor(Color.gray)
                        Spacer()
                        Text("Abgeschlossen").italic().foregroundColor(Color.gray)
                    }
                    
                    NavigationLink(destination: TaskDetailsView(ProjectId: "Aufgabe 2", Progress: 0.3)){
                        Text("Aufgabe 2")
                    }
                    
                    NavigationLink(destination: TaskDetailsView(ProjectId: "Aufgabe 3", Progress: 0.0)){
                        Text("Aufgabe 3")
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
            }.navigationBarTitle(ProjectId)
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
