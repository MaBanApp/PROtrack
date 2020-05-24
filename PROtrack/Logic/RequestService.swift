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
    
    //Get the projectinformations by ID
    func getProjectById(projectID: Int, completion: @escaping (ProjectPayload) -> Void) {
        let url:String = apiUrl + "/project/" + String(projectID) + "?user=" + userID
        
        AF.request(url, method: .get).response {response in
                        
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    let datapath = try json["payload"].rawData()
                    let data = try JSONDecoder().decode(ProjectPayload.self, from: datapath)
                    completion(data)
                } catch let error {
                    print("API Error: ", error)
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
    
    //Get the taskinformations by ID
    func getTaskById(taskID: Int, completion: @escaping (TaskPayload) -> Void) {
        let url:String = apiUrl + "/task/" + String(taskID) + "?user=" + userID
        
        AF.request(url, method: .get).response {response in
                        
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    let datapath = try json["payload"].rawData()
                    let data = try JSONDecoder().decode(TaskPayload.self, from: datapath)
                    completion(data)
                } catch let error {
                    print("API Error: ", error)
                }
        }

    }
    
    //Get all tasks wich are assigned to the userID
    func getTaskWithUser(userID: Int, completion: @escaping ([Int]) -> Void) {
        var taskIDs: [Int] = []
        
        getTasks() {data in
            for i in data.payload.indices {
                for ti in data.payload[i].users.indices {
                    if data.payload[i].users[ti].id == userID {
                        taskIDs.append(data.payload[i].users[ti].id)
                        print(taskIDs)
                    }
                }
            }
        completion(taskIDs)
        }
    }
    
    //Get a List of all Users registered
    func getUsers(projectID: Int, completion: @escaping ([UserData]) -> Void) {
        let url:String = apiUrl + "/users?user=" + userID

        if projectID == 0 {
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
        else
        {
            getProjectById(projectID: projectID) { data in
                completion(data.users)
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
    
    //Add user to a task
    func addUserToTask(taskID: Int, user: Int, completion: @escaping (String, Int) -> Void) {
        let url:String = apiUrl + "/project/" + String(taskID) +  "/user/" + String(user) + "?user=" + userID
          
           AF.request(url, method: .post).responseJSON {response in
              guard let data = response.data else { return }
                  do {
                      let json = JSON(data)
                      completion(json["message"].stringValue, json["status"].intValue)
                  }
          }
    }

    //Change the Status of the Project or Task, depending on wich ID was given
    func changeStatus(projectID: Int, taskID: Int, newStatus: Int, completion: @escaping (String, Int) -> Void) {
        var url:String = ""
        if taskID == 0 {
            url = apiUrl + "/project/" + String(projectID) +  "/status?user=" + userID
        }
        else
        {
            url = apiUrl + "/task/" + String(taskID) + "/status?user=" + userID
        }
        let params = ["status" : newStatus] as [String : Any]

        AF.request(url, method: .patch, parameters: params).response {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    completion(json["message"].stringValue, json["status"].intValue)
            }
        }
    }
    
    //Edit project
    func editProject (projectID: Int, title: String, desc: String, users: [Int], completion: @escaping (String, Int) -> Void) {
        let url:String = apiUrl + "/project/" + String(projectID) + "?user=" + userID
        let params = ["name" : title, "description" : desc]
        
        AF.request(url, method: .put, parameters: params).responseJSON {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    completion(json["message"].stringValue, json["status"].intValue)
                }
        }
    }

    //Edit task
    func editTask (taskID: Int, title: String, desc: String, guideTime: Int, completion: @escaping (String, Int) -> Void) {
        let url:String = apiUrl + "/task/" + String(taskID) + "?user=" + userID
        let params = ["title" : title, "description" : desc, "guide_time" : guideTime] as [String : Any]
        
        AF.request(url, method: .put, parameters: params).responseJSON {response in
            guard let data = response.data else { return }
                do {
                    let json = JSON(data)
                    completion(json["message"].stringValue, json["status"].intValue)
                }
        }
    }

}
