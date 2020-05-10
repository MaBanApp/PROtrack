//
//  UserCardView.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct UserCardView: View {
    
    @State var ProjectMember: [String]
    
    var body: some View {

        HStack {
            ForEach(0 ..< ProjectMember.count) {i in
                VStack {
                    Group{
                        Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                        Text(self.ProjectMember[i]).font(.system(size: 12)).frame(width: 55).fixedSize(horizontal: true, vertical: true).multilineTextAlignment(.center)
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
        
    @State var ProjectMember: [String]

    var body: some View {

        HStack {
            ForEach(0 ..< ProjectMember.count) {i in
                VStack {
                    Group{
                        Image(systemName: "person.crop.circle").font(.system(size: 40.0)).padding(8)
                        Text(self.ProjectMember[i]).font(.system(size: 12)).frame(width: 55).fixedSize(horizontal: true, vertical: true).multilineTextAlignment(.center)
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

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(ProjectMember: ["Marino Bantli", "Vladislav Juhasz", "Robin Portner"])
    }
}
