//
//  main.swift
//  peril
//
//  Created by John Pavley on 1/21/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

// enumerations

enum Location: String {
    case livingroom = "livingroom"
    case garden = "garden"
    case attic = "attic"
}

enum Direction: String {
    case upstairs = "upstairs"
    case downstairs = "downstairs"
    case north = "north"
    case south = "south"
    case east = "east"
    case west = "west"
}

enum Route: String {
    case door = "door"
    case ladder = "ladder"
}

enum Command: String {
    case look = "look"
    case walk = "walk"
    case pickup = "pickup"
    case inventory = "inventory"
}

// structures

struct Node {
    var location: Location
    var description: String
}

struct Edge {
    var orgin: Location
    var destination: Location
    var direciton: Direction
    var path: Route
}

struct Object {
    var description: String
    var position: String
}

struct Player {
    var location: Location
    var objects: [Object]
}

struct Room {
    var node: Node
    var edges: [Edge]
    var objects: [Object]
}

// classes

class Game {
    var player: Player = Player(location: .livingroom, objects: [Object]())
    var world: [Room] = []
    
    func describeLocation() -> String? {
        for room in world {
            if room.node.location == player.location {
                return room.node.description
            }
        }
        return nil
    }
    
    func describeEdges() -> String? {
        for room in world {
            if room.node.location == player.location {
                var result = ""
                for edge in room.edges {
                    result.append("There is a \(edge.path) going \(edge.direciton) from here.")
                    result.append(" ")
                }
                return result
            }
        }
        return nil
    }
    
    func describeObjects() -> String? {
        for room in world {
            if room.node.location == player.location {
                var result = ""
                for object in room.objects {
                    result.append("You see a \(object.description) on the \(object.position).")
                    result.append(" ")
                }
                return result
            }
        }
        return nil
    }
    
    func look() -> String {
        var result = ""
        result.append(describeLocation()!)
        result.append(" ")
        result.append(describeEdges()!)
        result.append(" ")
        result.append(describeObjects()!)
        return result
    }
}

// main

func main() {
    let game = Game()
    
    let livingroomNode = Node(location: .livingroom, description: "You are in the living-room. A wizard is snorning loudly on the couch.")
    let gardenNode = Node(location: .garden, description: "You are in a beautiful garden. There is a well in front of you.")
    let atticNode = Node(location: .attic, description: "You are in the attic. There is a giant welding a torch in the corner.")
    
    let livingroomEdge1 = Edge(orgin: .livingroom, destination: .garden, direciton: .west, path: .door)
    let livingroomEdge2 = Edge(orgin: .livingroom, destination: .attic, direciton: .upstairs, path: .ladder)
    let gardenEdge = Edge(orgin: .garden, destination: .livingroom, direciton: .east, path: .door)
    let atticEdge = Edge(orgin: .attic, destination: .livingroom, direciton: .downstairs, path: .ladder)
    
    let whiskeyObject = Object(description: "bottle", position: "floor")
    let bucketObject = Object(description: "bucket", position: "table")
    let frogObject = Object(description: "frog", position: "ground")
    let chainObject = Object(description: "chain", position: "grass")
    
    let room1 = Room(node: livingroomNode, edges: [livingroomEdge1, livingroomEdge2], objects: [whiskeyObject, bucketObject])
    let room2 = Room(node: gardenNode, edges: [gardenEdge], objects: [frogObject, chainObject])
    let room3 = Room(node: atticNode, edges: [atticEdge], objects: [Object]())
    
    
    game.world.append(room1)
    game.world.append(room2)
    game.world.append(room3)
    
    print("Welcome to the Peril. Enter at your risk.")
    print(" ")
    
    print(game.look())

}

main()













