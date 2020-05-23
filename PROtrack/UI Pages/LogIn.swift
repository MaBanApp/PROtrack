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
    
    @State var userData: [Int] = []
    @State var projData: ProjectResponse?
    @State private var alertShown: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        
        ZStack{
            VStack{
                HStack{
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
                            }.textContentType(.username)
                        }.padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                            .frame(width: UIScreen.main.bounds.width - 30, alignment: .center)

                        HStack {
                                Image(systemName: "lock").foregroundColor(.gray)
                                SecureField("Passwort", text: $Password).onTapGesture {
                                    self.Password = ""
                                }.textContentType(.password)
                            }.padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1))
                            .frame(width: UIScreen.main.bounds.width - 30, alignment: .center)
                        Spacer().frame(height: 20)
                    }
                Button(action: {
                    if AppDelegate().settings.string(forKey: "ServerURL") == nil {
                        self.message = "Keine Serveradresse angegeben"
                        self.alertShown.toggle()
                    }
                    else
                    {
                        RequestService().logOn(username: self.Username, password: self.Password) {result, message in
                            self.userData = result
                         
                            if !result.contains(0) {
                                RequestService().getProjects() {data in
                                    self.projData = data
                                    self.isLoggedIn.toggle()
                                }
                            }
                            else
                            {
                                self.message = message
                                self.alertShown.toggle()
                            }
                        }
                    }
                    self.endEditing()
                    }) {Text("Anmelden").bold().font(.system(size: 20))}
                    .alert(isPresented: self.$alertShown) {
                        Alert(title: Text("Fehler beim Anmelden"), message: Text(message), dismissButton: .default(Text("OK")))
                    }
                Spacer()
                }
            
            if isLoggedIn {
                if userData[1] == 2 {
                    ProjectOverviewView(userID: userData[0],
                                        projData: self.projData,
                                        isPresented: $isLoggedIn)
                }
                if userData[1] == 1 {
                    TaskOverviewView(userID: userData[0], isPresented: $isLoggedIn)
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
