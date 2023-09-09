//
//  Action.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 5/18/23.
//

import Core
import Terminal

@main
struct Action {
    static func main() async {
//        do {

            // Create a directory
//            let directoryPath = "my_directory"
//            try Core.Directory.create(atPath: directoryPath)
//
//
//
////             Create a file within the directory
//            let filePath = "\(directoryPath)/my_file.txt"
//            let fileContent = "Hello, World!".data(using: .utf8)
//            try Core.File.create(atPath: filePath, contents: fileContent)
         
//            // Read the contents of the file
//            let fileData = try Core.File.read(atPath: filePath)
//            if let fileString = String(data: fileData, encoding: .utf8) {
//                print("Contenido del archivo: \(fileString)")
//            }
//
//            // Move the file to another directory
//            let newDirectoryPath = "\(workspace)/new_directory"
//            try Core.Directory.create(atPath: newDirectoryPath)
//            _ = "\(newDirectoryPath)/my_file.txt"
//            //                    try Core.File.moveItem(atPath: filePath, toPath: newFilePath)
//
//            // Delete the directory and its contents
//            try Core.Directory.delete(atPath: directoryPath)
//            try Core.Directory.delete(atPath: newDirectoryPath)
//        } catch {
//            print("Error: \(error)")
//        }
//        let myInput = Core.getInput(name: "myInput")
//        print("Name: \(myInput ?? "N/A")")
//
//        let optionalInput = Core.getInput(name: "optionalInput")
//        print("OptionalInput: \(optionalInput ?? "N/A")")
//        Core.Outputs
        Core.Outputs.setOutput(name: "myOutput", value: "Testing the output")
//        Core.Outputs.setOutput(name: "myOutput", value: "Probando el output ")
    }
}


