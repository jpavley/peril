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
    
    // game info from game.jason
    var name = "The Peril"
    var welcome = "Welcome to the Peril. Enter at your own risk..."
    var prompt = "Enter a command:"
    var errorBadCommand = "Please restate the command."
    var errorBadPickup = "You can't pick that up."
    
    // Apple's suggestion way of JSON initialization
//    init?(json: [String: Any]) {
//        guard let gameInfoJSON = json["game-info"] as? [String:String],
//            let name = gameInfoJSON["name"],
//            let welcome = gameInfoJSON["welcome"],
//            let prompt = gameInfoJSON["prompt"],
//            let errorBadCommand = gameInfoJSON["error-bad-command"],
//            let errorBadPickup = gameInfoJSON["error-bad-pickup"]
//            else {
//                return nil
//        }
//        
//        self.name = name
//        self.welcome = welcome
//        self.prompt = prompt
//        self.errorBadCommand = errorBadCommand
//        self.errorBadPickup = errorBadPickup
//    }
    
    func readConfigFile(fileName: String, fileExtention: String) -> String? {
        var result = ""
        
        let currentPath = FileManager.default.currentDirectoryPath
        let pathURL = URL(fileURLWithPath: currentPath)
        let fileURL = pathURL.appendingPathComponent("\(fileName).\(fileExtention)")
        print(fileURL)
        do {
            result = try String(contentsOf: fileURL)
            print("Succeeded reading from URL: \(fileURL)")
            return result
        } catch {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }

        
        
//        let docDirectory = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//        if let fileURL = docDirectory?.appendingPathComponent(fileName).appendingPathExtension(fileExtention) {
//            do {
//                result = try String(contentsOf: fileURL)
//                print("Succeeded reading from URL: \(fileURL)")
//                return result
//            } catch {
//                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
//                return nil
//            }
//        }
        return nil
    }
    
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

