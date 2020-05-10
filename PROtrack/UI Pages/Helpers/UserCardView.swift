//
//  UserCardView.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct UserCardView: View {
    
    @Binding var SelectedMembers: [Int]
    
    @State var ProjectMemberFirstName: [String]
    @State var ProjectMemberLastName: [String]

    var body: some View {

        HStack {
            ForEach(0 ..< ProjectMemberFirstName.count) {i in
                VStack {
                    Group{
                        Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                        Text(self.ProjectMemberFirstName[i]).font(.system(size: 12))
                        Text(self.ProjectMemberLastName[i]).font(.system(size: 12))
                    }
                }.frame(width: 60, height: 85)
                .background(self.SelectedMembers.contains(where: {$0 == i}) ? Color.blue : Color("LightGray"))
                .cornerRadius(5)
                .onTapGesture {
                    //Select or unselect Members
                    if self.SelectedMembers.contains(where: {$0 == i}) {
                        self.SelectedMembers.remove(at: self.SelectedMembers.firstIndex(where: {$0 == i}) ?? 0)
                    } else {
                        self.SelectedMembers.append(i)
                    }
                }
            }
            
        }
    }
}
