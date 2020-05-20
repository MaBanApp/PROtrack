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
    
    let userID: String = String(AppDelegate().settings.integer(forKey: "UserID"))
    let apiUrl: String = AppDelegate().settings.string(forKey: "ServerURL")!

    //Returns array of "UserID" and "Role" and a Message from the API
    func logOn(username: String, password: String, completion: @escaping ([Int], String) -> Void) {
        let url:String = apiUrl + "/authenticate"
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
        let url:String = apiUrl + "/projects?user=" + userID
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
    
    //Get a List of all Tasks for the specific user
    func getTasks(completion: @escaping (TaskResponse) -> Void) {
        let url:String = apiUrl + "/tasks?user=" + userID
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
    
    //Get a List of all Users registered
    func getUsers(completion: @escaping ([UserData]) -> Void) {
        let url:String = apiUrl + "/users?user=" + userID
         
        AF.request(url, method: .get).response {response in
            guard let data = response.data else { return }
            do {
                let json = JSON(data)
                let datapath = try json["payload"].rawData()
                let data = try JSONDecoder().decode([UserData].self, from: datapath)
                completion(data)
            } catch let error {
                print("API Error: ", error)
            }
        }
    }
    
    //Update time records for Task
    func updateTimeRecords(taskID: Int, completion: @escaping ([TimeRecords]) -> Void) {
        let url:String = apiUrl + "/task/" + String(taskID) + "?user=" + userID

        AF.request(url, method: .get).response {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    let datapath = try json["payload"].rawData()
                    let data = try JSONDecoder().decode(TaskPayload.self, from: datapath)
                    completion(data.records)
                } catch let error {
                    print("API Error: ", error)
            }
        }

    }
    
    //Book time on Project
    func bookTime (taskID: Int , time: String, date: String, desc: String, completion: @escaping (Bool, String, Int) -> Void) {
        let url:String = apiUrl + "/task/" + String(taskID) + "/records?user=" + userID
        let params = ["user" : userID, "date" : date, "time" : time, "description" : desc] as [String : Any]
        
        AF.request(url, method: .post, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case let.success(data):
                do {
                    let json = JSON(data)
                    completion(true, json["message"].stringValue, json["status"].intValue)
                }
                
            case let.failure(error):
                print(error)
            }
            

        }
        
    }
    
    //Create new task
    func createTask(projectID: Int, title: String, desc: String, guideTime: String, Users: [Int], completion: @escaping (String, Int) -> Void) {
        let url:String = apiUrl + "/project/" + String(projectID) + "/tasks?user=" + userID
        let params = ["title" : title, "description" : desc , "guide_time" : guideTime] as [String : Any]
        
        AF.request(url, method: .post, parameters: params).responseJSON {response in
           guard let data = response.data else { return }
               do {
                   let json = JSON(data)
                   completion(json["message"].stringValue, json["status"].intValue)
               }
       }
        
    }
    
    //Create new project
    func createProject(title: String, desc: String, users: [Int], completion: @escaping (String, Int) -> Void) {
        let url:String = apiUrl + "/projects" + "?user=" + userID
        let params = ["name" : title, "description" : desc] as [String : Any]
         
         AF.request(url, method: .post, parameters: params).responseJSON {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    
                    for i in users.indices {
                        self.addUserToProject(projectID: json["payload"]["id"].intValue,  user: users[i]) { message, int in
                            if i == users.count - 1 {
                                completion(json["message"].stringValue, json["status"].intValue)
                            }
                        }

                    }
                }
        }
    }
    
    //Add user to a project
    func addUserToProject(projectID: Int, user: Int, completion: @escaping (String, Int) -> Void) {
        let url:String = apiUrl + "/project/" + String(projectID) +  "/user/" + String(user) + "?user=" + userID
        
         AF.request(url, method: .post).responseJSON {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    completion(json["message"].stringValue, json["status"].intValue)
                }
        }
        
    }

}
