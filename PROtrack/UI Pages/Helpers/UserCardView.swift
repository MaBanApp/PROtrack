//
//  UserCardView.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct UserCardView: View {
    
    @State var ProjectMember: [UserData]
    
    var body: some View {

        HStack {
            ForEach(ProjectMember.indices) {i in
                VStack {
                    Group{
                        Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                        Text(self.ProjectMember[i].name).font(.system(size: 12)).frame(width: 55).fixedSize(horizontal: true, vertical: true).multilineTextAlignment(.center)
                    }
                }.frame(width: 60, height: 85)
                .background(Color("LightGray"))
                .cornerRadius(5)

            }
            
        }
    }
}

struct UserCardViewSelectable: View {
    
    @Binding var SelectedMembers: [Int]
    @State var projectID: Int = 0
    
    @State private var ProjectMember: [UserData] = []
    @State private var ready: Bool = false

    var body: some View {

        HStack {
            if ready {
                ForEach(ProjectMember.indices, id: \.self) {i in
                    VStack {
                        Group{
                            Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                            Text(self.ProjectMember[i].name).font(.system(size: 12)).frame(width: 55).fixedSize(horizontal: true, vertical: true).multilineTextAlignment(.center)
                        }.onTapGesture {
                            self.selectUser(id: self.ProjectMember[i].id)
                        }
                    }.frame(width: 60, height: 85)
                    .background(self.SelectedMembers.contains(where: {$0 == self.ProjectMember[i].id}) ? Color.blue : Color("LightGray"))
                    .cornerRadius(5)
                }.id(UUID())
            }
        }.frame(height: 85)
        .onAppear() {
            RequestService().getUsers(projectID: self.projectID) {data in
                self.ProjectMember = data
                self.ready.toggle()
            }
        }
    }
    
    func selectUser(id: Int) {
        if SelectedMembers.contains(id) {
            self.SelectedMembers.removeAll { $0 == id }
        }
        else
        {
            self.SelectedMembers.append(id)
        }
    }
}
