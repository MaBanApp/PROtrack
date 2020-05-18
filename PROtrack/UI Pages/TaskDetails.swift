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
    @State var user: [UserData] = []
    @State var guideTime: String = ""
    @State var timeRecords: [TimeRecords] = []
    @State var taskID: Int = 0

    
    @State private var showTimeBook:Bool = false
    @State private var showingAlert = false
    @State private var progress: Float = 0
    @State private var isExpanded: Bool = false

    
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
                        Text(progressService().getBookedTime(bookedTime: timeRecords))
                    }
                    ProgressBar(value: $progress).frame(height:10)
                }.frame(height: 70)
                .onAppear() {
                    self.progress = progressService().getProgress(guideTime: self.guideTime, bookedTime: self.timeRecords)
            }
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
                        UserCardView(ProjectMember: ["user"] )
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
                ForEach (0..<timeRecords.count) {i in
                    VStack (alignment: .leading) {
                        HStack {
                            Text(self.timeRecords[i].date).frame(width: 120, alignment: .leading)
                            //Text("\(self.timeRecords[i].date.timestamp)")
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
                }
            }
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
                TimeView(taskID: self.taskID, isPresented: self.$showTimeBook)
            }
        )

    }
    
}

struct TaskDetailsView_preview: PreviewProvider {
    static var previews: some View {
        TaskDetailsView()
    }
}
