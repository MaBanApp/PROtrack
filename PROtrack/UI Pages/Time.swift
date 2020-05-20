//
//  Time.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct TimeView: View {
    
    //Initalizer vars
    @State var taskID: Int = 0
    
    //Private vars
    @State private var time:String = ""
    @State private var date = Date()
    @State private var notes:String = ""
    @State private var userID: Int = AppDelegate().settings.integer(forKey: "UserID")
    @State private var APImessage: String = ""
    
    //UI Vars
    @Binding var isPresented: Bool
    @State private var isEditing:Bool = false
    @State private var showingAlert: Bool = false
    
    
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
                    Button("Erfassen") {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .medium
                        RequestService().bookTime(taskID: self.taskID, time: self.time, date: formatter.string(from: self.date), desc: self.notes) { didFinish, message, status in
                            if status < 300 {
                                self.APImessage = message
                                DispatchQueue.main.async {
                                    self.showingAlert.toggle()
                                }
                                
                            }
                            else
                            {
                                self.APImessage = message
                                self.showingAlert.toggle()
                            }
                        }
                    }
            )
            .listStyle(GroupedListStyle())

        }.alert(isPresented: self.$showingAlert) {
                Alert(title: Text("Zeit gebucht"), message: Text(APImessage), dismissButton: .default(Text("OK").bold(), action: {
                    self.isPresented.toggle()
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
