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
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Offene Aufgaben")) {
                    Text("Nothing here")
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
