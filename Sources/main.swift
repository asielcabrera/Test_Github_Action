import Foundation 
public struct Core {
    public static func getInput(name: String, options: InputOptions = .init()) -> String? {
        let inputKey = "INPUT_\(name.uppercased())"
        let defaultValue = options.defaultValue
        
        if let value = ProcessInfo.processInfo.environment[inputKey], !value.isEmpty {
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
//        print("::set-output name=\(name)::\(value)")
        
//        echo "{name}={value}" >> $GITHUB_OUTPUT
        
        func exec(_ path: String, _ args: String...) -> Int32 {
                let task = Process()
                    task.launchPath = path
                    task.arguments = args
                    task.launch()
                    task.waitUntilExit()
                
                return task.terminationStatus
            }

        
        _ = exec("/bin/sh", "-c", " echo \"\(name)=\(value)\" >> $GITHUB_OUTPUT")
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
print("Valor de name: \(myInput ?? "N/A")")

Core.setOutput(name: "myOutput", value: "test output")
