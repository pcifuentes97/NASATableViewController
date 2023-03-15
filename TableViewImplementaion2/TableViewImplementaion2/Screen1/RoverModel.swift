//
//  RoverModel.swift
//  TableViewImplementaion2
//
//  Created by Paolo Cifuentes on 11/19/21.
//

import Foundation


struct Photos: Decodable {
    var photos: [Rover]
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
}

struct Rover: Decodable {
    var id: Int
    var imgSrc: String
    var favorite: Bool = false
    var earthDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imgSrc = "img_src"
        case earthDate = "earth_date"
    }
}
