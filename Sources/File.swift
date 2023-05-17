////
////  File.swift
////  
////
////  Created by Asiel Cabrera Gonzalez on 5/17/23.
////
//
//import Foundation
//
///**
// 
// Interface for getInput options
// */
//public struct InputOptions {
//    /// Optional. Whether the input is required. If required and not present, will throw. Defaults to false
//    public var required: Bool?
//    /// Optional. Whether leading/trailing whitespace will be trimmed for the input. Defaults to true
//    public var trimWhitespace: Bool?
//}
//
///**
// 
// The code to exit an action
// **/
//public enum ExitCode: Int {
//    /*
//     A code indicating that the action was successful
//     */
//    case success = 0
//    /**
//     
//     A code indicating that the action was a failure
//     */
//    case failure = 1
//}
///**
// 
// Optional properties that can be sent with annotation commands (notice, error, and warning)
// See: https://docs.github.com/en/rest/reference/checks#create-a-check-run for more information about annotations.
// **/
//public struct AnnotationProperties {
//    /*
//     A title for the annotation.
//     */
//    public var title: String?
//    /**
//     
//     The path of the file for which the annotation should be created.
//     */
//    public var file: String?
//    /**
//     
//     The start line for the annotation.
//     */
//    public var startLine: Int?
//    /**
//     
//     The end line for the annotation. Defaults to startLine when startLine is provided.
//     */
//    public var endLine: Int?
//    /**
//     
//     The start column for the annotation. Cannot be sent when startLine and endLine are different values.
//     */
//    public var startColumn: Int?
//    /**
//     
//     The end column for the annotation. Cannot be sent when startLine and endLine are different values.
//     Defaults to startColumn when startColumn is provided.
//     */
//    public var endColumn: Int?
//    
//    public var isEmpty: Bool {
//        return self.title == nil
//    }
//}
////-----------------------------------------------------------------------
//// Variables
////-----------------------------------------------------------------------
//
///**
// 
// Sets env variable for this action and future actions in the job
// @param name the name of the variable to set
// @param val the value of the variable. Non-string values will be converted to a string via JSON.stringify
// */
//
//public func exportVariable(name: String, val: String) {
//    let convertedVal = toCommandValue(val)
//    let proccess = Process()
//    proccess.environment?[name] = convertedVal
//    let filePath = ProcessInfo.processInfo.environment["GITHUB_ENV"] ?? ""
//    if !filePath.isEmpty {
//        return issueFileCommand("ENV", prepareKeyValueMessage(name, val))
//    }
//    
//    issueCommand("set-env", CommandProperties(properties: ["name": name]), convertedVal)
//}
//
///**
// 
// Registers a secret which will get masked from logs
// @param secret value of the secret
// */
//public func setSecret(secret: String) {
//    issueCommand("add-mask", CommandProperties(properties: [:]), secret)
//}
///**
// 
// Prepends inputPath to the PATH (for this action and future actions)
// @param inputPath
// */
//public func addPath(inputPath: String) {
//    let filePath = ProcessInfo.processInfo.environment["GITHUB_PATH"] ?? ""
//    if !filePath.isEmpty {
//        issueFileCommand("PATH", inputPath)
//    } else {
//        issueCommand("add-path", .init(properties: [:]), inputPath)
//    }
//    let proccess = Process()
//    
//    
//    proccess.environment?["PATH"] = "\(inputPath)\(String.pathSeparator)\(ProcessInfo.processInfo.environment["PATH"] ?? "")"
//}
///**
// 
// Gets the value of an input.
// Unless trimWhitespace is set to false in InputOptions, the value is also trimmed.
// Returns an empty string if the value is not defined.
// @param name name of the input to get
// @param options optional. See InputOptions.
// @returns string
// */
//public func getInput(name: String, options: InputOptions? = nil) -> String {
//    let val: String = ProcessInfo.processInfo.environment["INPUT_\(name.replacingOccurrences(of: " ", with: "_").uppercased())"] ?? ""
//    if let options = options, let required = options.required, required && val.isEmpty {
//        fatalError("Input required and not supplied: (name)")
//    }
//    if let options = options, let trimWhitespace = options.trimWhitespace, !trimWhitespace {
//        return val
//    }
//    
//    return val.trimmingCharacters(in: .whitespacesAndNewlines)
//}
//
///**
// 
// Gets the values of an multiline input. Each value is also trimmed.
// @param name name of the input to get
// @param options optional. See InputOptions.
// @returns string[]
// */
//public func getMultilineInput(name: String, options: InputOptions? = nil) -> [String] {
//    let inputs: [String] = getInput(name: name, options: options)
//        .components(separatedBy: .newlines)
//        .filter { !$0.isEmpty }
//    if let options = options, let trimWhitespace = options.trimWhitespace, !trimWhitespace {
//        return inputs
//    }
//    
//    return inputs.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//}
//
///**
// 
// Gets the input value of the boolean type in the YAML 1.2 "core schema" specification.
// Support boolean input list: true | True | TRUE | false | False | FALSE .
// The return value is also in boolean type.
// ref: https://yaml.org/spec/1.2/spec.html#id2804923
// @param name name of the input to get
// @param options optional. See InputOptions.
// @returns boolean
// */
//public func getBooleanInput(name: String, options: InputOptions? = nil) -> Bool {
//    let trueValues = ["true", "True", "TRUE"]
//    let falseValues = ["false", "False", "FALSE"]
//    let val = getInput(name: name, options: options)
//    if trueValues.contains(val) { return true }
//    if falseValues.contains(val) { return false }
//    fatalError("Input does not meet YAML 1.2 \"Core Schema\" specification: \(name)\nSupport boolean input list: true | True | TRUE | false | False | FALSE")
//}
///**
// 
// Sets the value of an output.
// @param name name of the output to set
// @param value value to store. Non-string values will be converted to a string via JSON.stringify
// */
//// eslint-disable-next-line @typescript-eslint/no-explicit-any
//public func setOutput(name: String, value: String) {
//    let filePath = ProcessInfo.processInfo.environment["GITHUB_OUTPUT"] ?? ""
//    if !filePath.isEmpty {
//        return issueFileCommand("OUTPUT", prepareKeyValueMessage(name, value))
//    }
//    print("\n")
//    issueCommand("set-output", CommandProperties(properties: ["name": name]), toCommandValue(value))
//}
//
///**
// 
// Enables or disables the echoing of commands into stdout for the rest of the step.
// Echoing is disabled by default if ACTIONS_STEP_DEBUG is not set.
// */
//public func setCommandEcho(enabled: Bool) {
//    issue("echo", enabled ? "on" : "off")
//}
//
////-----------------------------------------------------------------------
//// Results
////-----------------------------------------------------------------------
//
///**
// 
// Sets the action status to failed.
// When the action exits it will be with an exit code of 1
// @param message add error issue message
// */
//public func setFailed(message: String) {
//    let exitCode = ExitCode.failure.rawValue
//    error(message, properties: .init())
//}
//
////-----------------------------------------------------------------------
//// Logging Commands
////-----------------------------------------------------------------------
//
///**
// 
// Gets whether Actions Step Debug is on or not
// */
//public func is_Debug() -> Bool {
//    return ProcessInfo.processInfo.environment["RUNNER_DEBUG"] == "1"
//}
///**
// 
// Writes debug message to user log
// @param message debug message
// */
//public func debug(_ message: String) {
//    issueCommand("debug", CommandProperties(properties: [:]), message)
//}
///**
// 
// Adds an error issue
// @param message error issue message. Errors will be converted to string via toString()
// @param properties optional properties to add to the annotation.
// */
//public func error(
//    _ message: String,
//    properties: AnnotationProperties
//) {
//    issueCommand(
//        "error",
//        toCommandProperties(properties),
//        message
//    )
//}
///**
// 
// Adds a warning issue
// @param message warning issue message. Errors will be converted to string via toString()
// @param properties optional properties to add to the annotation.
// */
//public func warning(
//    _ message: String,
//    properties: AnnotationProperties
//) {
//    issueCommand(
//        "warning",
//        toCommandProperties(properties),
//        message
//    )
//}
///**
// 
// Adds a notice issue
// @param message notice issue message. Errors will be converted to string via toString()
// @param properties optional properties to add to the annotation.
// */
//public func notice(
//    _ message: String,
//    properties: AnnotationProperties
//) {
//    issueCommand(
//        "notice",
//        toCommandProperties(properties),
//        message
//    )
//}
///**
// 
// Writes info to log with console.log.
// @param message info message
// */
//public func info(_ message: String) {
//    print(message)
//}
///**
// 
// Begin an output group.
// Output until the next groupEnd will be foldable in this group
// @param name The name of the output group
// */
//public func startGroup(_ name: String) {
//    issue("group", name)
//}
///**
// 
// End an output group.
// */
//public func endGroup() {
//    issue("endgroup")
//}
///**
// 
// Wrap an asynchronous function call in a group.
// Returns the same type as the function itself.
// @param name The name of the group
// @param fn The function to wrap in the group
// */
//public func group<T>(_ name: String, _ fn: () -> T) -> T {
//    startGroup(name)
//    let result: T
//    
//    result = fn()
//    
//    endGroup()
//    
//    return result
//}
//
////-----------------------------------------------------------------------
//// Wrapper action state
////-----------------------------------------------------------------------
//
///**
// 
// Saves state for current action, the state can only be retrieved by this action's post job execution.
// @param name name of the state to store
// @param value value to store. Non-string values will be converted to a string via JSON.stringify
// */
//// eslint-disable-next-line @typescript-eslint/no-explicit-any
//public func saveState(_ name: String, _ value: String) {
//    let filePath = ProcessInfo.processInfo.environment["GITHUB_STATE"] ?? ""
//    if !filePath.isEmpty {
//        return issueFileCommand("STATE", prepareKeyValueMessage(name, value))
//    }
//    issueCommand("save-state", .init(properties: ["name": name]), toCommandValue(value))
//}
//
///**
// 
// Gets the value of an state set by this action's main execution.
// @param name name of the state to get
// @returns string
// */
//public func getState(_ name: String) -> String {
//    return ProcessInfo.processInfo.environment["STATE_(name)"] ?? ""
//}
//public func getIDToken(aud: String? = nil) throws -> String {
//    return try OidcClient.getIDToken(audience: aud)
//}
//
//public func getAccessToken(aud: String? = nil) -> String {
//    return OidcClient.getAccessToken(aud: aud)
//}
//
//public func getBearerToken(aud: String? = nil) -> String {
//    return OidcClient.getBearerToken(aud: aud)
//}
//
//
//func issueFileCommand(_ command: String, _ message: String) {
//    guard let filePath = ProcessInfo.processInfo.environment["GITHUB_\(command)"] else {
//        fatalError("Unable to find environment variable for file command \(command)")
//    }
//    
//    if !FileManager.default.fileExists(atPath: filePath) {
//        fatalError("Missing file at path: \(filePath)")
//    }
//    
//    let convertedMessage = toCommandValue(message)
//    let appendedMessage = "\(convertedMessage)\(ProcessInfo.processInfo.environment["NS_NEWLINE"] ?? "")"
//    
//    if let fileHandle = FileHandle(forWritingAtPath: filePath) {
//        fileHandle.seekToEndOfFile()
//        fileHandle.write(Data(appendedMessage.utf8))
//        fileHandle.closeFile()
//    } else {
//        fatalError("Failed to open file at path: \(filePath)")
//    }
//}
//
//func prepareKeyValueMessage(_ key: String, _ value: String) -> String {
//    let delimiter = "ghadelimiter_\(UUID().uuidString)"
//    let convertedValue = toCommandValue(value)
//    
//    if key.contains(delimiter) {
//        fatalError("Unexpected input: name should not contain the delimiter \"\(delimiter)\"")
//    }
//    
//    if convertedValue.contains(delimiter) {
//        fatalError("Unexpected input: value should not contain the delimiter \"\(delimiter)\"")
//    }
//    
//    return "\(key)<<\(delimiter)\(ProcessInfo.processInfo.environment["NS_NEWLINE"] ?? "")\(convertedValue)\(ProcessInfo.processInfo.environment["NS_NEWLINE"] ?? "")\(delimiter)"
//}
//
//
////struct CommandProperties: Codable {
////    let title: String
////    let file: String
////    let line: Int
////    let endLine: Int
////    let col: Int
////    let endColumn: Int
////}
//
//func toCommandValue(_ input: String) -> String {
//    if input is NSNull || input == nil {
//        return ""
//    } else if let stringInput = input as? String {
//        return stringInput
//    }
//    let jsonEncoder = JSONEncoder()
//    if let jsonData = try? jsonEncoder.encode(input),
//        let jsonString = String(data: jsonData, encoding: .utf8) {
//        return jsonString
//    }
//    return ""
//}
//
//func toCommandProperties(_ annotationProperties: AnnotationProperties) -> CommandProperties {
//    guard !annotationProperties.isEmpty else {
//        return CommandProperties(properties: ["title" : "",
//                                              "file" : "",
//                                              "line" : "",
//                                              "endLine" : "",
//                                              "col" : "",
//                                              "endColumn" : ""])
//    }
//    
//    return CommandProperties(
//        properties: ["title" : annotationProperties.title!,
//                     "file" : annotationProperties.file!,
//                     "line" : annotationProperties.startLine!,
//                     "endLine" : annotationProperties.endLine!,
//                     "col" : annotationProperties.startColumn!,
//                     "endColumn" : annotationProperties.endColumn!]
//    )
//}
//
//struct CommandProperties {
//    var properties: [String: Any]
//}
//
//func issueCommand(_ command: String, _ properties: CommandProperties, _ message: String) {
//    let cmd = Command(command: command, properties: properties, message: message)
//    let cmdString = cmd.toString()
//    print(cmdString)
//}
//
//func issue(_ name: String, _ message: String = "") {
//    issueCommand(name, CommandProperties(properties: [:]), message)
//}
//
//private let CMD_STRING = "::"
//
//struct Command {
//    let command: String
//    let properties: CommandProperties
//    let message: String
//    
//    init(command: String, properties: CommandProperties, message: String) {
//        self.command = command.isEmpty ? "missing.command" : command
//        self.properties = properties
//        self.message = message
//    }
//    
//    func toString() -> String {
//        var cmdStr = CMD_STRING + command
//        
//        if !properties.properties.isEmpty {
//            cmdStr += " "
//            var first = true
//            for (key, value) in properties.properties {
//                if let val = value {
//                    if first {
//                        first = false
//                    } else {
//                        cmdStr += ","
//                    }
//                    
//                    cmdStr += "\(key)=\(escapeProperty(val as! String))"
//                }
//            }
//        }
//        
//        cmdStr += "\(CMD_STRING)\(escapeData(message))"
//        return cmdStr
//    }
//}
//
//func escapeData(_ s: String) -> String {
//    return toCommandValue(s)
//        .replacingOccurrences(of: "%", with: "%25")
//        .replacingOccurrences(of: "\r", with: "%0D")
//        .replacingOccurrences(of: "\n", with: "%0A")
//}
//
//func escapeProperty(_ s: String) -> String {
//    return toCommandValue(s)
//        .replacingOccurrences(of: "%", with: "%25")
//        .replacingOccurrences(of: "\r", with: "%0D")
//        .replacingOccurrences(of: "\n", with: "%0A")
//        .replacingOccurrences(of: ":", with: "%3A")
//        .replacingOccurrences(of: ",", with: "%2C")
//}
//
//
//
//
//struct TokenResponse: Decodable {
//    let value: String?
//}
//
//class OidcClient {
//    static func createHttpClient(allowRetry: Bool = true, maxRetry: Int = 10) -> HttpClient {
//        let requestOptions = RequestOptions(allowRetries: allowRetry, maxRetries: maxRetry)
//        return HttpClient("actions/oidc-client", [BearerCredentialHandler(getRequestToken())], requestOptions)
//    }
//    
//    static func getRequestToken() -> String {
//        guard let token = ProcessInfo.processInfo.environment["ACTIONS_ID_TOKEN_REQUEST_TOKEN"] else {
//            fatalError("Unable to get ACTIONS_ID_TOKEN_REQUEST_TOKEN env variable")
//        }
//        return token
//    }
//    
//    static func getIDTokenUrl() -> String {
//        guard let runtimeUrl = ProcessInfo.processInfo.environment["ACTIONS_ID_TOKEN_REQUEST_URL"] else {
//            fatalError("Unable to get ACTIONS_ID_TOKEN_REQUEST_URL env variable")
//        }
//        return runtimeUrl
//    }
//    
//    static func getCall(idTokenUrl: String) throws -> String {
//        let httpClient = createHttpClient()
//        
//        guard let url = URL(string: idTokenUrl) else {
//            fatalError("Invalid ID token URL")
//        }
//        
//        let semaphore = DispatchSemaphore(value: 0)
//        var idToken: String?
//        var error: Error?
//        
//        let task = httpClient.get(url: url) { response in
//            do {
//                guard let data = response.body else {
//                    throw NSError(domain: "Response data is empty", code: 0, userInfo: nil)
//                }
//                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
//                idToken = tokenResponse.value
//            } catch let decodingError {
//                error = decodingError
//            }
//            semaphore.signal()
//        }
//        
//        task.resume()
//        semaphore.wait()
//        
//        if let error = error {
//            throw error
//        }
//        
//        guard let token = idToken else {
//            throw NSError(domain: "Response json body do not have ID Token field", code: 0, userInfo: nil)
//        }
//        
//        return token
//    }
//    
//    static func getIDToken(audience: String? = nil) throws -> String {
//        do {
//            var idTokenUrl = getIDTokenUrl()
//            if let audience = audience {
//                let encodedAudience = audience.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                idTokenUrl = "\(idTokenUrl)&audience=\(encodedAudience)"
//            }
//            
//            print("ID token url is \(idTokenUrl)")
//            
//            let idToken = try getCall(idTokenUrl: idTokenUrl)
//            setSecret(idToken)
//            return idToken
//        } catch let error {
//            throw error
//        }
//    }
//}
//
//
//func toPosixPath(_ path: String) -> String {
//    return path.replacingOccurrences(of: "\\", with: "/")
//}
//
//func toWin32Path(_ path: String) -> String {
//    return path.replacingOccurrences(of: "/", with: "\\")
//}
//
//func toPlatformPath(_ path: String) -> String {
//    return path.replacingOccurrences(of: "/", with: pathSeparator)
//                 .replacingOccurrences(of: "\\", with: pathSeparator)
//}
//
//let pathSeparator = FileManager.default.pathSeparator
//
//
//public let SUMMARY_ENV_VAR = "GITHUB_STEP_SUMMARY"
//public let SUMMARY_DOCS_URL = "https://docs.github.com/actions/using-workflows/workflow-commands-for-github-actions#adding-a-job-summary"
//
//public struct SummaryTableCell {
//    public let data: String
//    public let header: Bool?
//    public let colspan: String?
//    public let rowspan: String?
//    
//    public init(data: String, header: Bool? = false, colspan: String? = "1", rowspan: String? = "1") {
//        self.data = data
//        self.header = header
//        self.colspan = colspan
//        self.rowspan = rowspan
//    }
//}
//
//public struct SummaryImageOptions {
//    public let width: String?
//    public let height: String?
//    
//    public init(width: String? = nil, height: String? = nil) {
//        self.width = width
//        self.height = height
//    }
//}
//
//public struct SummaryWriteOptions {
//    public let overwrite: Bool
//    
//    public init(overwrite: Bool = false) {
//        self.overwrite = overwrite
//    }
//}
//
//public class Summary {
//    private var buffer: String
//    private var filePath: String?
//    
//    public init() {
//        buffer = ""
//    }
//    
//    private func file_Path() throws -> String {
//        if let filePath = filePath {
//            return filePath
//        }
//        
//        guard let pathFromEnv = ProcessInfo.processInfo.environment[SUMMARY_ENV_VAR] else {
//            throw NSError(domain: "", code: 0, userInfo: [
//                NSLocalizedDescriptionKey: "Unable to find environment variable for $\(SUMMARY_ENV_VAR). Check if your runtime environment supports job summaries."
//            ])
//        }
//        
//        guard FileManager.default.isReadableFile(atPath: pathFromEnv) && FileManager.default.isWritableFile(atPath: pathFromEnv) else {
//            throw NSError(domain: "", code: 0, userInfo: [
//                NSLocalizedDescriptionKey: "Unable to access summary file: '\(pathFromEnv)'. Check if the file has correct read/write permissions."
//            ])
//        }
//        
//        filePath = pathFromEnv
//        return filePath!
//    }
//    
//    private func wrap(tag: String, content: String?, attrs: [String: String] = [:]) -> String {
//        let htmlAttrs = attrs.map { key, value in
//            " \(key)=\"\(value)\""
//        }.joined()
//        
//        if let content = content {
//            return "<\(tag)\(htmlAttrs)>\(content)</\(tag)>"
//        } else {
//            return "<\(tag)\(htmlAttrs)>"
//        }
//    }
//    
//    public func write(options: SummaryWriteOptions? = nil) throws -> Summary {
//        let overwrite = options?.overwrite ?? false
//        let filePath = try self.file_Path()
//        let writeFunc: (String, Data, [FileAttributeKey: Any]) throws -> Void = overwrite ? FileManager.default.createFile(atPath:contents:attributes:) : FileManager.default.appendContentsOfFile(atPath:contents:)
//        try writeFunc(filePath, buffer.data(using: .utf8)!, [:])
//        return emptyBuffer()
//    }
//    
//    public func clear() throws -> Summary {
//        try emptyBuffer().write(options: SummaryWriteOptions(overwrite: true))
//    }
//    
//    public func stringify() -> String {
//        buffer
//    }
//    
//    public func isEmptyBuffer() -> Bool {
//        buffer.isEmpty
//    }
//    
//    public func emptyBuffer() -> Summary {
//        buffer = ""
//        return self
//    }
//    
//    public func addRaw(_ text: String, addEOL: Bool = false) -> Summary {
//        buffer += text
//       
//        if addEOL {
//            return self.addEOL()
//        } else {
//            return self
//        }
//    }
//    
//    public func addEOL() -> Summary {
//        return addRaw("\n")
//    }
//    
//    public func addCodeBlock(_ code: String, lang: String? = nil) -> Summary {
//        var attrs: [String: String] = [:]
//        if let lang = lang {
//            attrs["lang"] = lang
//        }
//        let element = wrap(tag: "pre", content: wrap(tag: "code", content: code), attrs: attrs)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addList(_ items: [String], ordered: Bool = false) -> Summary {
//        let tag = ordered ? "ol" : "ul"
//        let listItems = items.map { item in
//            wrap(tag: "li", content: item)
//        }.joined()
//        let element = wrap(tag: tag, content: listItems)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addTable(_ rows: [[SummaryTableCell]]) -> Summary {
//        let tableBody = rows.map { row in
//            let cells = row.map { cell in
//                if let header = cell.header, header {
//                    return wrap(tag: "th", content: cell.data)
//                } else {
//                    var attrs: [String: String] = [:]
//                    if let colspan = cell.colspan {
//                        attrs["colspan"] = colspan
//                    }
//                    if let rowspan = cell.rowspan {
//                        attrs["rowspan"] = rowspan
//                    }
//                    return wrap(tag: "td", content: cell.data, attrs: attrs)
//                }
//            }.joined()
//            return wrap(tag: "tr", content: cells)
//        }.joined()
//        
//        let element = wrap(tag: "table", content: tableBody)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addDetails(_ label: String, content: String) -> Summary {
//        let element = wrap(tag: "details", content: wrap(tag: "summary", content: label) + content)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addImage(_ src: String, alt: String, options: SummaryImageOptions? = nil) -> Summary {
//        let width = options?.width
//        let height = options?.height
//        var attrs: [String: String] = [:]
//        if let width = width {
//            attrs["width"] = width
//        }
//        if let height = height {
//            attrs["height"] = height
//        }
//        let element = wrap(tag: "img", content: nil, attrs: attrs.merging(["src": src, "alt": alt], uniquingKeysWith: { $1 }))
//        return addRaw(element).addEOL()
//    }
//    
//    public func addHeading(_ text: String, level: Int = 1) -> Summary {
//        let tag = "h\(min(max(level, 1), 6))"
//        let element = wrap(tag: tag, content: text)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addSeparator() -> Summary {
//        let element = wrap(tag: "hr", content: nil)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addBreak() -> Summary {
//        let element = wrap(tag: "br", content: nil)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addQuote(_ text: String, cite: String? = nil) -> Summary {
//        var attrs: [String: String] = [:]
//        if let cite = cite {
//            attrs["cite"] = cite
//        }
//       
//        let element = wrap(tag: "blockquote", content: text, attrs: attrs)
//        return addRaw(element).addEOL()
//    }
//    
//    public func addLink(_ text: String, href: String) -> Summary {
//        let element = wrap(tag: "a", content: text, attrs: ["href": href])
//        return addRaw(element).addEOL()
//    }
//}
//
//let summary = Summary()
//
///**
// * @deprecated use `summary`
// */
//public let markdownSummary = summary
