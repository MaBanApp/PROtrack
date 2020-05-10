//
//  TaskDetails.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TaskDetailsView: View {

    
    @State var name: String = ""
    @State var desc: String = ""
    @State var user: [String] = []
    @State var guideTime: String = ""
    @State var timeRecords: [Int] = []
    
    
    @State var Progress:Float = 0.33
    
    @State var showTimeBook:Bool = false

    @State var showingAlert = false

    
    var body: some View {
        
        List{
            Section(header: Text("Aufgabenfortschritt")){
                VStack{
                    HStack{
                        Text("Richtzeit:")
                        Spacer()
                        Text("\(guideTime) Minuten")
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
            
            
        }.navigationBarTitle(name)
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
