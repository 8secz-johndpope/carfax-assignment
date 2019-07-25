import Foundation

public struct ImagesResponse: JSONDeserializable {
    public internal(set) var smallURLs: [String] = []
    public internal(set) var mediumURLs: [String] = []
    public internal(set) var largeURLs: [String] = []
    public internal(set) var firstImage: FirstListingsImageResponse?
    
    public init() {}
    
    public init(json: JSONDictionary) throws {
        smallURLs = try decode(json, key: "small")
        mediumURLs = try decode(json, key: "medium")
        largeURLs = try decode(json, key: "large")
        firstImage = try? decode(json, key: "firstPhoto")
    }
}
