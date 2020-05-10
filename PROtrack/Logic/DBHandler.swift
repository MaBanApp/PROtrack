//
//  DBHandler.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class DBHandler {
    
    //Get a List of all Projects
    func getProjects(completion: @escaping (ProjectResponse) -> Void) {
        
        let url:String = AppDelegate().settings.string(forKey: "ServerURL")! + "/projects"
        
        AF.request(url, method: .get).response {response in
                        
            guard let data = response.data else { return }
                do {
                    let data = try JSONDecoder().decode(ProjectResponse.self, from: data)
                    completion(data)
                } catch let error {
                    print(error)
                }
        }
    }
    
    
    func getSelectedUser(firstName: [String], lastName: [String], selected: [Int]) -> [String]{
        
        var SelectedUser: [String] = []
        
        for i in(0 ..< selected.count) {
            SelectedUser.append(firstName[selected[i]])
            SelectedUser.append(lastName[selected[i]])
        }
    
        return SelectedUser
    }

}
