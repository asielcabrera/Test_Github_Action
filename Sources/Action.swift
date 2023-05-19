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
        do {
            let workspace = Core.Environment.getWorkflow()!
            
            print(workspace)
            
            // Crear un directorio
            let directoryPath = "my_directory"
            try Core.Directory.create(atPath: directoryPath)
            
            let ter = Terminal(type: .bash)
            print(try ter.execute("ls"))
            
            // Crear un archivo dentro del directorio
//            let filePath = "\(directoryPath)/my_file.txt"
//            let fileContent = "Hello, World!".data(using: .utf8)
//            try Core.File.create(atPath: filePath, contents: fileContent)
//
//            // Leer el contenido del archivo
//            let fileData = try Core.File.read(atPath: filePath)
//            if let fileString = String(data: fileData, encoding: .utf8) {
//                print("Contenido del archivo: \(fileString)")
//            }
//
//            // Mover el archivo a otro directorio
//            let newDirectoryPath = "\(workspace)/new_directory"
//            try Core.Directory.create(atPath: newDirectoryPath)
//            _ = "\(newDirectoryPath)/my_file.txt"
//            //                    try Core.File.moveItem(atPath: filePath, toPath: newFilePath)
//
//            // Eliminar el directorio y su contenido
//            try Core.Directory.delete(atPath: directoryPath)
//            try Core.Directory.delete(atPath: newDirectoryPath)
        } catch {
            print("Error: \(error)")
        }
//        let myInput = Core.getInput(name: "myInput")
//        print("Valor de name: \(myInput ?? "N/A")")
//
//        let optionalInput = Core.getInput(name: "optionalInput")
//        print("Valor de optionalInput: \(optionalInput ?? "N/A")")
//
//        Core.setOutput(name: "myOutput", value: "Probando el output")
    }
}


