//
//  main.swift
//  peril
//
//  Created by John Pavley on 1/21/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

func readConfigFile(fileName: String, fileExtention: String) -> String? {
    var result = ""
    let docDirectory = try? FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    if let fileURL = docDirectory?.appendingPathComponent(fileName).appendingPathExtension(fileExtention) {
        do {
            result = try String(contentsOf: fileURL)
            print("Succeeded reading from URL: \(fileURL)")
            return result
        } catch {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            return nil
        }
    }
    return nil
}


// main

func main() {
    
    let configFileName = "game"
    let configFileExtension = "json"
    
    if let configFileString = readConfigFile(fileName: configFileName, fileExtention: configFileExtension) {
        let jsonString = configFileString.data(using: .utf8)!
        if let actualJSON = try? JSONSerialization.jsonObject(with: jsonString) as! [String:Any],
            let game = Game(json: actualJSON) {
            
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
            
            let livingroomEdge1 = Edge(origin: "living room", destination: "garden", direction: "west", path: "door")
            let livingroomEdge2 = Edge(origin: "living room", destination: "attic", direction: "upstairs", path: "ladder")
            let gardenEdge = Edge(origin: "garden", destination: "living room", direction: "east", path: "door")
            let atticEdge = Edge(origin: "attic", destination: "living room", direction: "downstairs", path: "ladder")
            
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
            
            print(game.name)
            print(game.welcome)
            print(" ")
            print(game.look(userInput: ""))
            
            // game loop
            
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
                    } else {
                        print(game.errorBadCommand)
                    }
                }
            }
        }
    }
}


main()













