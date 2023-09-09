//
//  Action.swift
//
//
//  Created by Asiel Cabrera Gonzalez on 5/18/23.
//

import Core


@main
struct Action {
    static func main() async {
        let myInput = try! Core.getInput("myinput")
        print(myInput)
        
        Core.setOutput(name: "myOutput", value: "testing frase from output")
    }
}


