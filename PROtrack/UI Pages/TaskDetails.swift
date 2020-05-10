//
//  TaskDetails.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TaskDetailsView: View {

    
    @State public var ProjectId: String = "Aufgabe"
    @State public var Progress:Float = 0.33
    
    @State var showTimeBook:Bool = false

    @State var showingAlert = false

    
    var body: some View {
        
        List{
            Section(header: Text("Aufgabenfortschritt")){
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
            
                        Spacer()
                    }.frame(height:86, alignment: .top)
                }

            }
            Section(header: Text("Erfasste Zeiten")){
                
                Text("Hier könnte Ihre Zeit stehen...")
                
            }
            Section(header: Text("Aufgabe verwalten")){
             
                Button("Aufgabe bearbeiten"){
                    print("edit pressed")
                }.foregroundColor(Color.blue)
                Button("Aufgabe abschliessen"){
                    self.showingAlert = true
                }.foregroundColor(Color.red).alert(isPresented: $showingAlert) {
                    Alert(title: Text("Aufgabe abschliessen"), message: Text("Sind Sie sicher, dass die Aufgabe abgeschlossen werden soll ?"), primaryButton: .default(Text("Ja").bold(), action: {
                                print("Confirmed")
                        }), secondaryButton: .default(Text("Nein")))}
            }.listStyle(GroupedListStyle())
            
            
        }.navigationBarTitle(ProjectId)
        .navigationBarItems(trailing:
            Button("Zeit erfassen") {
                self.showTimeBook = true
            }.sheet(isPresented: $showTimeBook){
                TimeView(isPresented: self.$showTimeBook)
            }
        )
        
        
    }
}

struct TaskDetailsView_preview: PreviewProvider {
    static var previews: some View {
        TaskDetailsView()
    }
}
