import Foundation 


let myInput = Core.getInput(name: "myInput")
print("Valor de name: \(myInput ?? "N/A")")

Core.setOutput(name: "myOutput", value: "Probando el output")
