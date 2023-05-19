//
//  Action.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 5/18/23.
//

import Core

@main
struct Action {
    static func main() {
        do {
            // Crear un directorio
            try Core.Directory.create(atPath: "my_directory")
            
            // Crear un archivo dentro del directorio
            let filePath = "my_directory/my_file.txt"
            let fileContent = "Hello, World!".data(using: .utf8)
            try Core.File.create(atPath: filePath, contents: fileContent)
            
            // Leer el contenido del archivo
            let fileData = try Core.File.read(atPath: filePath)
            if let fileString = String(data: fileData, encoding: .utf8) {
                print("Contenido del archivo: \(fileString)")
            }
            
            // Mover el archivo a otro directorio
            let newDirectoryPath = "new_directory"
            try Core.Directory.create(atPath: newDirectoryPath)
            let newFilePath = "\(newDirectoryPath)/my_file.txt"
            try Core.Directory.moveItem(atPath: filePath, toPath: newFilePath)
            
            // Eliminar el directorio y su contenido
            try Core.Directory.delete(atPath: "my_directory")
            try Core.Directory.delete(atPath: newDirectoryPath)
        } catch {
            print("Error: \(error)")
        }
        let myInput = Core.getInput(name: "myInput")
        print("Valor de name: \(myInput ?? "N/A")")
        
        let optionalInput = Core.getInput(name: "optionalInput")
        print("Valor de optionalInput: \(optionalInput ?? "N/A")")
        
        Core.setOutput(name: "myOutput", value: "Probando el output")
    }
}


