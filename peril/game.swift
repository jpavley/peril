//
//  game.swift
//  peril
//
//  Created by John Pavley on 3/18/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

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
                if userInput == edge.direction {
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

