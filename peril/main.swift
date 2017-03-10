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
    var orgin: String
    var destination: String
    var direction: Direction
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


// classes

class Game {
    var player = Player(location: "living room", pocket: Loot(objects: []))
    var world: [String:Room] = [:]
    //  var commands = [Command]()
    var commands: [String:Command] = [:]
    var gameOver = false
    
    func describeLocation() -> String? {
        return world[player.location]?.node.description
    }
    
    func describeEdges() -> String? {
        if let room = world[player.location] {
            var result = ""
            for edge in room.edges {
                result.append("There is a \(edge.path) going \(edge.direction) from here.")
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
    
    func look(userInput: String) -> String {
        var result = ""
        if userInput == "" {
            result.append(describeLocation()!)
            result.append(" ")
            result.append(describeEdges()!)
            result.append(" ")
            result.append(describeObjects()!)
        } else {
            result = "Looking at \(userInput) doesn't help"
        }
        return result
    }
    
    func inventory(userInput: String) -> String {
        var result = "In your pocket you found: "
        if userInput == "" {
            if player.pocket.countObjects() == 0 {
                result.append("nothing.")
            } else {
                result.append(player.pocket.listObjects())
            }
        } else {
            result = "\(userInput) doesn't have any pockets"
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
                if userInput == edge.direction.rawValue {
                    player.location = edge.destination
                    result = look(userInput: "")
                    break
                }
            }
        }
        
        return result
    }
    
    func pickup(userInput: String) -> String {
        var result = "You can't pick that up."
        
        // early return
        if userInput == "Please restate the command" {
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
    
    func quit(userInput: String) -> String {
        var result = ""
        if userInput == "" {
            result = "Thanks for playing!"
            gameOver = true
        } else {
            result = "Can't stop \(userInput)."
        }
        return result
    }
}

// main

func main() {
    let game = Game()
    
    let greeting = "Enter a command:"
    
    let lookCommand = Command(id: 100, name: "look", description: "Returns the description of something.", action: game.look)
    let walkCommand = Command(id: 102, name: "walk", description: "Moves the player in a direction.", action: game.walk)
    let pickUpCommand = Command(id: 104, name: "pickup", description: "Places something in the player's pocket.", action: game.pickup)
    let inventoryCommand = Command(id: 106, name: "inventory", description: "List the contents of the players pocket.", action: game.inventory)
    let quitCommand = Command(id: 108, name: "quit", description: "Exits the game.", action: game.quit)
    
    game.commands["look"] = lookCommand
    game.commands["walk"] = walkCommand
    game.commands["pickup"] = pickUpCommand
    game.commands["inventory"] = inventoryCommand
    game.commands["quit"] = quitCommand
    
    let livingroomNode = Node(name: "living room", description: "You are in the living room. A wizard is snorning loudly on the couch.")
    let gardenNode = Node(name: "garden", description: "You are in a beautiful garden. There is a well in front of you.")
    let atticNode = Node(name: "attic", description: "You are in the attic. There is a giant welding a torch in the corner.")
    
    let livingroomEdge1 = Edge(orgin: "living room", destination: "garden", direction: .west, path: "door")
    let livingroomEdge2 = Edge(orgin: "living room", destination: "attic", direction: .upstairs, path: "ladder")
    let gardenEdge = Edge(orgin: "garden", destination: "living room", direction: .east, path: "door")
    let atticEdge = Edge(orgin: "attic", destination: "living room", direction: .downstairs, path: "ladder")
    
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
    print(game.look(userInput: ""))
    
    
    while !game.gameOver {
        print(" ")
        print(greeting, terminator: " ")

        if let userInput = readLine() {
            
            let normalizedUserInput = userInput.lowercased()
            
            let userCommands = normalizedUserInput.components(separatedBy: " ")
            
            if let cmd = game.commands[userCommands[0]] {
                var userInput = ""
                if userCommands.count > 1 {
                    userInput = userCommands[1]
                }
                print(cmd.action(userInput))
            }
        }
    }
}

main()













