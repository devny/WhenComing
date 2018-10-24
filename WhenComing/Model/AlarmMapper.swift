//
//  AlarmMapper.swift
//  WhenComing
//
//  Created by 장혜준 on 24/10/2018.
//  Copyright © 2018 장혜준. All rights reserved.
//

import ObjectMapper

struct AlarmData: Mappable {
    
    var alarmList: [Alarm] = []
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.alarmList <- map["data"]
    }
    
}


struct Alarm: Mappable {
    
    var id: String?
    var alarm_time: String?
    var arsId: String?
    var busRouteId: String?
    var bus: String?
    var created_at: String?
    var updated_at: String?
    var day: String?
    var device_id: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.alarm_time <- map["alarm_time"]
        self.arsId <- map["arsId"]
        self.busRouteId <- map["busRouteId"]
        self.bus <- map["bus"]
        self.created_at <- map["created_at"]
        self.updated_at <- map["updated_at"]
        self.day <- map["day"]
        self.device_id <- map["device_id"]
    }
    
}

