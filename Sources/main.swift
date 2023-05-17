import Foundation 
public struct Core {
    public static func getInput(name: String, options: InputOptions = .init()) -> String? {
        let inputKey = "INPUT_\(name.uppercased())"
        let defaultValue = options.defaultValue
        
        let proccess = Process()
        
        if let value = proccess.environment?[inputKey], !value.isEmpty {
            return value
        }
        
        if let value = defaultValue, !value.isEmpty {
            return value
        }
        
        if options.required {
            fatalError("Input '\(name)' is required but not provided.")
        }
        
        return nil
    }
    
    public static func getBooleanInput(name: String, options: InputOptions = .init()) -> Bool {
        guard let value = getInput(name: name, options: options) else {
            return false
        }
        return ["true", "1", "yes", "on"].contains(value.lowercased())
    }
    
    public static func setOutput(name: String, value: String) {
        print("::set-output name=\(name)::\(value)")
    }
    
    public static func setFailed(message: String) {
        print("::error::\(message)")
        exit(1)
    }
    
    public static func setSecret(name: String, value: String) {
        print("::add-mask::$\(value)")
        setOutput(name: name, value: value)
    }
    
    public static func debug(message: String) {
        print("::debug::\(message)")
    }
    
    public struct InputOptions {
        public let required: Bool
        public let defaultValue: String?
        
        public init(required: Bool = false, defaultValue: String? = nil) {
            self.required = required
            self.defaultValue = defaultValue
        }
    }
    
    // Agrega aquí otras funcionalidades según sea necesario
}

let myInput = Core.getInput(name: "myInput")
print("Valor de myInput: \(myInput ?? "N/A")")

// Obtener una entrada booleana
let isDebug = Core.getBooleanInput(name: "debug")
print("¿Es modo de depuración? \(isDebug)")

// Establecer el valor de una salida
Core.setOutput(name: "myOutput", value: "Hello, world!")

// Establecer un valor secreto y sensible
Core.setSecret(name: "mySecret", value: "s3cr3t")

// let secret = Core.getSecret(name: "mySecret")

// Imprimir un mensaje de depuración
Core.debug(message: "Esto es un mensaje de depuración")

// Indicar que la acción ha fallado
// Core.setFailed(message: "Algo salió mal. La acción ha fallado.")
