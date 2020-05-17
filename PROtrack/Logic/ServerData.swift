//
//  ServerData.swift
//  PROtrack
//
//  Created by Marino Bantli on 09.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import Foundation

struct ProjectResponse: Codable {
    let message     : String
    let status      : Int
    let payload     : [ProjectPayload]
}

struct TaskResponse: Codable {
    let message     : String
    let status      : Int
    let payload     : [TaskPayload]
}

struct ProjectPayload: Codable {
    let id          : Int
    let name        : String
    let description : String
    let status      : Int
    let tasks       : [TaskPayload]
    let users       : [UserData]
}

struct TaskPayload: Codable {
    let id          : Int
    let title       : String
    let description : String
    let guide_time  : String
    let status      : Int
    let users       : [UserData]
    let records     : [TimeRecords]
}

struct UserData: Codable {
    let id          : Int
    let name        : String
    let role        : Int
}

struct TimeRecords: Codable {
    let id          : Int
    let task        : Int
    let user        : UserData
    let description : String
    let date        : String
    let time        : String
}
