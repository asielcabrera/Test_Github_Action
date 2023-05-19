//
//  Action.swift
//  
//
//  Created by Asiel Cabrera Gonzalez on 5/18/23.
//

import Core
import Github

@main
struct Action {
    static func main() {
        
        let myInput = Core.getInput(name: "myInput")
        print("Valor de name: \(myInput ?? "N/A")")
        
        let optionalInput = Core.getInput(name: "optionalInput")
        print("Valor de optionalInput: \(optionalInput ?? "N/A")")
        
        Core.setOutput(name: "myOutput", value: "Probando el output")
    }
}
