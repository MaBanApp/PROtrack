//
//  Time.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TimeView: View {
    
    @State var time:String = ""
    @State var date = Date()
    @State var notes:String = ""
    
    @Binding var isPresented: Bool
    @State var isEditing:Bool = false
    
    
    var body: some View {
        
        NavigationView {
            
            List{
                Section(header: Text("Datum")){
                    DatePicker("Datum auswählen", selection: $date, displayedComponents: .date)
                }.onTapGesture {
                    self.endEditing()
                }
                Section(header: Text("Zeit")){
                    HStack {
                        Text("Benötigte Zeit")
                        TextField("Minuten", text: $time).keyboardType(.numberPad)
                    }
                    }.onTapGesture {
                        if !self.isEditing {
                            self.endEditing()
                            self.isEditing = false
                        }
                        else
                        {
                            self.isEditing.toggle()
                        }
                    }
                Section(header: Text("Bemerkungen")){
                    TextField("Bemerkungen", text: $notes).onTapGesture {
                if !self.isEditing {
                    self.endEditing()
                    self.isEditing = false
                }
                else
                {
                    self.isEditing.toggle()
                }
                
                }
                }
            }.navigationBarTitle(Text("Zeit erfassen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
                    Button("Erfassen") { print("Project created")}
            )
            .listStyle(GroupedListStyle())

        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func endEditing() {
        let keyWindow = UIApplication.shared.connectedScenes
                               .filter({$0.activationState == .foregroundActive})
                               .map({$0 as? UIWindowScene})
                               .compactMap({$0})
                               .first?.windows
                               .filter({$0.isKeyWindow}).first
                       keyWindow?.endEditing(true)
    }
    
}
