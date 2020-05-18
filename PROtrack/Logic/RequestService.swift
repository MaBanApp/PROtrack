//
//  RequestService.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RequestService {

    //Returns array of "UserID" and "Role" and a Message from the API
    func logOn(username: String, password: String, completion: @escaping ([Int], String) -> Void) {
        let url:String = AppDelegate().settings.string(forKey: "ServerURL")! + "/authenticate"
        var result:[Int] = []
        
        let params = ["username" : username, "password" : password]
        
        AF.request(url, method: .post, parameters: params).responseJSON {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    result = [json["payload"]["id"].intValue, json["payload"]["role"].intValue]
                    AppDelegate().settings.setValue(json["payload"]["id"].intValue, forKey: "UserID")
                    completion(result, json["message"].stringValue)
                }
        }
    }
    
    //Get a List of all Projects
    func getProjects(completion: @escaping (ProjectResponse) -> Void) {
        
        let url:String = AppDelegate().settings.string(forKey: "ServerURL")! + "/projects?user=" + String(AppDelegate().settings.integer(forKey: "UserID"))
        
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
    
    //Get a List of all Projects
    func getTasks(completion: @escaping (TaskResponse) -> Void) {
        
        let url:String = AppDelegate().settings.string(forKey: "ServerURL")! + "/tasks?user=" + String(AppDelegate().settings.integer(forKey: "UserID"))
        
        AF.request(url, method: .get).response {response in
                        
            guard let data = response.data else { return }
                do {
                    let data = try JSONDecoder().decode(TaskResponse.self, from: data)
                    completion(data)
                } catch let error {
                    print("API Error: ", error)
                }
        }
    }
    
    //Book time on Project
    func bookTime (taskID: Int , time: String, date: String, desc: String, completion: @escaping (Bool, String, Int) -> Void) {
        let userID = String(AppDelegate().settings.integer(forKey: "UserID"))
        let url:String = AppDelegate().settings.string(forKey: "ServerURL")! + "/task/" + String(taskID) + "/records?user=" + userID
        let params = ["user" : userID, "date" : date, "time" : time, "description" : desc] as [String : Any]
        
        AF.request(url, method: .post, parameters: params).responseJSON {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    completion(true, json["message"].stringValue, json["status"].intValue)
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
