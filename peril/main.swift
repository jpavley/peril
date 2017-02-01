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
    var pocket = Catalog(objects: [])
}

struct Room {
    var node: Node
    var edges: [Edge]
    var cache = Catalog(objects: [])
}

struct Catalog {
    var objects: [Object]
    
    func countObjects() -> Int {
        return objects.count
    }
    
    func listObjects() -> String {
        var result = ""
        for o in objects {
            result.append(o.name)
            result.append(" ")
        }
        return result.trimmingCharacters(in: .whitespaces)
    }
    
    mutating func addObject(o: Object) {
        objects.append(o)
    }
    
    mutating func removeObject(o: Object) {
        var removeIndex = -1
        for (i, object) in objects.enumerated() {
            if object.name == o.name {
                removeIndex = i
                break
            }
        }
        if removeIndex > -1 {
            objects.remove(at: removeIndex)
        }
    }
}


// classes

class Game {
    var player = Player(location: "living room", pocket: Catalog(objects: []))
    var world: [Room] = []
    
    func describeLocation() -> String? {
        for room in world {
            if room.node.name == player.location {
                return room.node.description
            }
        }
        return nil
    }
    
    func describeEdges() -> String? {
        for room in world {
            if room.node.name == player.location {
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
            if room.node.name == player.location {
                var result = ""
                for object in room.cache.objects {
                    result.append("You see a \(object.name) on the \(object.position).")
                    result.append(" ")
                }
                return result
            }
        }
        return nil
    }
    
    func playerRoom() -> Room? {
        for room in world {
            if room.node.name == player.location {
                return room
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
    
    func inventory() -> String {
        var result = "In your pocket you found: "
        if player.pocket.countObjects() == 0 {
            result.append("nothing")
        } else {
            result.append(player.pocket.listObjects())
        }
        return result
    }
    
    func pickup(userInput: String) -> String {
        var result = "You can't pick that up"
        
        if let room = playerRoom() {
            for object in room.objects {
                if userInput == object.name {
                    result = "You pickup the \(userInput)"
                    player.pocket.addObject(o: object)
                }
            }
        }
        
        return result
    }
}

// main

func main() {
    let game = Game()
    
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
    let chainObject = Object(name: "chain", position: "grass")
    
    let room1 = Room(node: livingroomNode, edges: [livingroomEdge1, livingroomEdge2], objects: [whiskeyObject, bucketObject])
    let room2 = Room(node: gardenNode, edges: [gardenEdge], objects: [frogObject, chainObject])
    let room3 = Room(node: atticNode, edges: [atticEdge], objects: [Object]())
    
    
    game.world.append(room1)
    game.world.append(room2)
    game.world.append(room3)
    
    print("Welcome to the Peril. Enter at your risk.")
    print(" ")
    
    print("Enter a command: ")
    
    var gameOver = false
    
    while !gameOver {
        if let userInput = readLine() {
            
            let userCommands = userInput.components(separatedBy: " ")
            
            switch userCommands[0] {
                
            case Command.look.rawValue:
                print(game.look())
                
            case Command.quit.rawValue:
                gameOver = true
                
            case Command.inventory.rawValue:
                print(game.inventory())
                
            case Command.pickup.rawValue:
                print(game.pickup(userInput: userCommands[1]))
                
            case Command.walk.rawValue:
                print(game.look())
                
            default:
                print("I don't understand.")
            }
        }

    }
    

}

main()













