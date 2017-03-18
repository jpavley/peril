//
//  data-structures.swift
//  peril
//
//  Created by John Pavley on 3/18/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

// structures

struct Command {
    var id: Int
    var name: String
    var description: String
    var action: (String) -> (String)
}

struct Node {
    var name: String
    var description: String
}

struct Edge {
    var origin: String
    var destination: String
    var direction: String
    var path: String
}

struct Object {
    var name: String
    var position: String
}

struct Player {
    var location: String
    var pocket = Loot(objects: [])
}

struct Room {
    var node: Node
    var edges: [Edge]
    var cache = Loot(objects: [])
}

struct Loot {
    var objects: [Object]
    
    func countObjects() -> Int {
        return objects.count
    }
    
    func listObjects() -> String {
        var result = ""
        for (i, o) in objects.enumerated() {
            result.append(o.name)
            if i < objects.endIndex - 1 {
                result.append(", ")
            } else {
                result.append(". ")
            }
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
    
    mutating func addObject(o: Object) {
        objects.append(o)
    }
}
