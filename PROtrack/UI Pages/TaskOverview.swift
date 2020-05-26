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
    @State private var tasksIDs : [Int] = []
    @State private var taskData : TaskResponse?
    
    //UI vars
    @State private var ready    : Bool = false
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Offene Aufgaben")){
                    if ready {
                        ForEach(taskData!.payload.indices) {i in
                            if self.tasksIDs.contains(self.taskData!.payload[i].id){
                                if self.taskData!.payload[i].status == 1 {
                                    NavigationLink(destination: TaskDetailsView(taskID: self.taskData!.payload[i].id,
                                                                                isFinished: false)){
                                        Text(self.taskData!.payload[i].title)
                                    }
                                }
                            }
                        }.id(UUID())
                    }
                    else
                    {
                        Text("Lade aufgaben...").italic().foregroundColor(Color.gray)
                    }
                }
                Section(header: Text("Abgeschlossene Aufgaben")) {
                    if ready {
                        ForEach(taskData!.payload.indices) {i in
                            if self.tasksIDs.contains(self.taskData!.payload[i].id){
                                if self.taskData!.payload[i].status == 2 {
                                    NavigationLink(destination: TaskDetailsView(taskID: self.taskData!.payload[i].id,
                                                                                isFinished: false)){
                                        Text(self.taskData!.payload[i].title)
                                    }
                                }
                            }
                        }.id(UUID())
                    }
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
        RequestService().getTaskWithUser(userID: userID) {tID in
            self.tasksIDs = tID
            RequestService().getTasks() {data in
                self.taskData = data
                self.ready = true
            }
        }
    }
}
