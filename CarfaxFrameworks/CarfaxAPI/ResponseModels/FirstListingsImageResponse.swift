import Foundation

public struct FirstListingsImageResponse: JSONDeserializable {
    public internal(set) var small: String = ""
    public internal(set) var medium: String = ""
    public internal(set) var large: String = ""
    
    public init() {}
    
    public init(json: JSONDictionary) throws {
        small = try decode(json, key: "small")
        medium = try decode(json, key: "medium")
        large = try decode(json, key: "large")
    }
}
