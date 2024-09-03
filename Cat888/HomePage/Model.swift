//
//  Model.swift
//  Cat888
//
//  Created by Владимир Кацап on 02.09.2024.
//

import Foundation


struct Pet: Codable {
    var image: Data
    var name: String
    var health: Int
    var age: String
    var gender: String
    var weight: String
    var breed: String
    var desk: String
    var tasks: [Task]
    
    init(image: Data, name: String, health: Int, age: String, gender: String, weight: String, breed: String, desk: String, tasks: [Task]) {
        self.image = image
        self.name = name
        self.health = health
        self.age = age
        self.gender = gender
        self.weight = weight
        self.breed = breed
        self.desk = desk
        self.tasks = tasks
    }
    
}


struct Task: Codable {
    var text: String
    var isComplete: Bool
    
    init(text: String, isComplete: Bool) {
        self.text = text
        self.isComplete = isComplete
    }
}
