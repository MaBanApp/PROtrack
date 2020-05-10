//
//  Settings.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    @Binding var isPresented:Bool
    
    @State var url:String = AppDelegate().settings.string(forKey: "ServerURL") ?? "https://"
    
    var body: some View {
        
        NavigationView{
            
            List{
                Section(header: Text("Servereinstellungen")) {
                    TextField("Serveradresse", text: $url)
                }
                
            }.navigationBarTitle(Text("Einstellungen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
                Button("Übernehmen") {
                    AppDelegate().settings.set(self.url, forKey: "ServerURL")
                    self.isPresented = false
                }
            )
            .listStyle(GroupedListStyle())
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
}
