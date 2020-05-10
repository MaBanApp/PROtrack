//
//  LogIn.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    
    @State var Username: String = ""
    @State var Password: String = ""
    @State var isLoggedIn: Bool = false
    @State var settingsShown:Bool = false

    
    var body: some View {
        
        ZStack{
            
            VStack{

                HStack{
                    Button("Test API") {
                        AppDelegate().dbhandler.getProjects(){result in
                            
                            let data: ProjectResponse = result
                            print("Raw JSON: ", result)
                            
                            print("------------------")
                            print("Status: ", data.status)
                            print("Message: ", data.message)
                            print("------------------")
                            print("Project id: ", data.payload[0].id)
                            print("Project name: ", data.payload[0].name)
                            print("Project users: ", data.payload[0].users)
                            print("Project status: ", data.payload[0].status)
                            print("Project description: ", data.payload[0].description)
                            print("Project tasks: ", data.payload[0].tasks.count)
                            print("------------------")
                            print("Task id: ", data.payload[0].tasks[0].id)
                            print("Task title: ", data.payload[0].tasks[0].title)
                            print("Task description: ", data.payload[0].tasks[0].description)
                            print("Task guidetime: ", data.payload[0].tasks[0].guideTime)
                            print("Task timerecords: ", data.payload[0].tasks[0].timeRecords)
                            print("Task users: ", data.payload[0].tasks[0].users)
                            print("Task status: ", data.payload[0].tasks[0].status)
                            print("------------------")
                            
                        }
                    }
                    Spacer()
                    Image(systemName: "gear").foregroundColor(.blue).font(.system(size: 20.0)).padding(15).onTapGesture {
                        self.settingsShown.toggle()
                    }.sheet(isPresented: $settingsShown){
                        SettingView(isPresented: self.$settingsShown)
                    }
                }
                
                Group{
                        Spacer().frame(height: 40)
                        Text("Willkommen bei PROtrack").bold().font(.system(size: 28))
                        Spacer().frame(height: 60)
                        Text("Bitte loggen Sie sich ein").italic().padding().frame(width: UIScreen.main.bounds.width, height: 30, alignment: .leading)
                        Spacer().frame(height: 5)
                        HStack {
                            Image(systemName: "person").foregroundColor(.gray)
                            TextField("Benutzername", text: $Username).onTapGesture {
                                self.Username = ""
                            }
                        }.padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                            .frame(width: UIScreen.main.bounds.width - 30, alignment: .center)

                        HStack {
                                Image(systemName: "lock").foregroundColor(.gray)
                                SecureField("Passwort", text: $Password).onTapGesture {
                                    self.Password = ""
                                }
                            }.padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                            .frame(width: UIScreen.main.bounds.width - 30, alignment: .center)
                    
                        Spacer().frame(height: 20)
                        Button(action: {print()
                            self.isLoggedIn = true
                            self.endEditing()
                        }) {Text("Anmelden").bold().font(.system(size: 20))}
                        Spacer()
                    }
                }

            
            if isLoggedIn {
                if Username == "Admin" {
                    ProjectOverviewView(isPresented: $isLoggedIn)
                }
                if Username == "User" {
                    TaskOverviewView(isPresented: $isLoggedIn)
                }
            }
        }
        
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

struct LogInView_Preview: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
