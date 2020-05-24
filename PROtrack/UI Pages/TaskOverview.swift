//
//  TaskOverview.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TaskOverviewView: View {
                
    //Initalizer vars
    @State var userID           : Int
    @Binding var isPresented    : Bool
    
    //Data vars
    @State var taskData         : TaskPayload?
    
    //UI vars
    @State private var ready    : Bool = false
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Offene Aufgaben")){
                    if ready {
                        Text("Keine Aufgaben")
                    }
                    else
                    {
                        Text("Lade aufgaben...").italic().foregroundColor(Color.gray)
                    }
                }
                Section(header: Text("Abgeschlossene Aufgaben")) {
                    Text("Noch keine abgeschlossenen Aufgaben").italic().foregroundColor(Color.gray)
                }
            }.listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Meine Aufgaben"))
        .navigationBarItems(leading:
        Button("Abmelden") { self.isPresented = false})
        }.onAppear() {
            self.updateView()
        }

    }
    
}

//View-dependend functions
extension TaskOverviewView {
    func updateView() {
        RequestService().getTaskWithUser(userID: userID) {data in
            self.ready = true
        }
    }
}
