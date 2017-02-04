//
//  main.swift
//  peril
//
//  Created by John Pavley on 1/21/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

// enumerations

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
    case quit = "quit"
    case drop = "drop"
}

// structures

struct Node {
    var name: String
    var description: String
}

struct Edge {
    var orgin: String
    var destination: String
    var direciton: Direction
    var path: Route
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


// classes

class Game {
    var player = Player(location: "living room", pocket: Loot(objects: []))
    var world: [String:Room] = [:]
    
    func describeLocation() -> String? {
        return world[player.location]?.node.description
    }
    
    func describeEdges() -> String? {
        if let room = world[player.location] {
            var result = ""
            for edge in room.edges {
                result.append("There is a \(edge.path) going \(edge.direciton) from here.")
                result.append(" ")
            }
            return result
        }
        
        return nil
    }
    
    func describeObjects() -> String? {
        if let room = world[player.location] {
            var result = ""
            for object in room.cache.objects {
                result.append("You see a \(object.name) on the \(object.position).")
                result.append(" ")
            }
            return result
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
    
    func inventory() -> String {
        var result = "In your pocket you found: "
        if player.pocket.countObjects() == 0 {
            result.append("nothing.")
        } else {
            result.append(player.pocket.listObjects())
        }
        return result
    }
    
    func walk(userInput: String) -> String {
        var result = "You can't walk there."
        
        // early return
        if userInput == "" {
            return result
        }

        if let room = world[player.location] {
            for edge in room.edges {
                if userInput == edge.direciton.rawValue {
                    player.location = edge.destination
                    result = look()
                }
            }
        }
        
        return result
    }
    
    func pickup(userInput: String) -> String {
        var result = "You can't pick that up."
        
        // early return
        if userInput == "" {
            return result
        }
        
        if let room = world[player.location] {
            for (i, object) in room.cache.objects.enumerated() {
                if userInput == object.name {
                    result = "You pickup the \(userInput)."
                    player.pocket.addObject(o: object)
                    world[room.node.name]?.cache.objects.remove(at: i)
                }
            }
        }
        
        return result
    }
}

// main

func main() {
    let game = Game()
    
    let greeting = "Enter a command:"
    
    let livingroomNode = Node(name: "living room", description: "You are in the living room. A wizard is snorning loudly on the couch.")
    let gardenNode = Node(name: "garden", description: "You are in a beautiful garden. There is a well in front of you.")
    let atticNode = Node(name: "attic", description: "You are in the attic. There is a giant welding a torch in the corner.")
    
    let livingroomEdge1 = Edge(orgin: "living room", destination: "garden", direciton: .west, path: .door)
    let livingroomEdge2 = Edge(orgin: "living room", destination: "attic", direciton: .upstairs, path: .ladder)
    let gardenEdge = Edge(orgin: "garden", destination: "living room", direciton: .east, path: .door)
    let atticEdge = Edge(orgin: "attic", destination: "living room", direciton: .downstairs, path: .ladder)
    
    let whiskeyObject = Object(name: "bottle", position: "floor")
    let bucketObject = Object(name: "bucket", position: "table")
    let frogObject = Object(name: "frog", position: "ground")
    let chainObject = Object(name: "key", position: "grass")
    let ringObject = Object(name: "ring", position: "box")
    
    let room1 = Room(node: livingroomNode, edges: [livingroomEdge1, livingroomEdge2], cache: Loot(objects: [whiskeyObject, bucketObject]))
    let room2 = Room(node: gardenNode, edges: [gardenEdge], cache: Loot(objects: [frogObject, chainObject]))
    let room3 = Room(node: atticNode, edges: [atticEdge], cache: Loot(objects: [ringObject]))
    
    
    game.world["living room"] = room1
    game.world["garden"] = room2
    game.world["attic"] = room3
    
    print("Welcome to the Peril. Enter at your risk.")
    print(" ")
    
    var gameOver = false
    
    while !gameOver {
        print(greeting, terminator: " ")

        if let userInput = readLine() {
            
            let normalizedUserInput = userInput.lowercased()
            
            let userCommands = normalizedUserInput.components(separatedBy: " ")
            
            switch userCommands[0] {
                
            case Command.look.rawValue:
                print(game.look())
                
            case Command.quit.rawValue:
                gameOver = true
                
            case Command.inventory.rawValue:
                print(game.inventory())
                
            case Command.pickup.rawValue:
                if userCommands.count > 1 {
                    print(game.pickup(userInput: userCommands[1]))
                } else {
                    print("Please restate the command.")
                }
                
            case Command.walk.rawValue:
                if userCommands.count > 1 {
                    print(game.walk(userInput: userCommands[1]))
                } else {
                    print("Please restate the command.")
                }
                
            default:
                print("I don't understand \(userInput).")
            }
        }
    }
    

}

main()













