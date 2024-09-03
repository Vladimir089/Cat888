//
//  ModelDoc.swift
//  Cat888
//
//  Created by Владимир Кацап on 03.09.2024.
//

import Foundation

struct Document: Codable {
    var image: Data
    var name: String
    var desk: String
    var images: [PhotoAndDescription]
    
    init(image: Data, name: String, desk: String, images: [PhotoAndDescription]) {
        self.image = image
        self.name = name
        self.desk = desk
        self.images = images
    }
}


struct PhotoAndDescription: Codable {
    var text: String
    var image: Data
    
    init(text: String, image: Data) {
        self.text = text
        self.image = image
    }
}
