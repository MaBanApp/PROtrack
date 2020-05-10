//
//  ServerData.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import Foundation

struct ProjectResponse: Codable {
    let message: String
    let status: Int
    let payload: [ProjectData]
}

struct ProjectData: Codable {
    
    let id: Int
    let users: [String]
    let name: String
    let status: Int
    let tasks: [TaskData]
    let description: String
    
}

struct TaskData: Codable {
    
    let description: String
    let project: Int
    let id: Int
    let status: Int
    let guideTime: String
    let timeRecords: [Int]
    let users: [String]
    let title: String
}
