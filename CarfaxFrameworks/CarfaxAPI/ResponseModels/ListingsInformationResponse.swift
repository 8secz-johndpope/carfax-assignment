import Foundation

public struct ListingsInformationResponse: JSONDeserializable {
    public internal(set) var listings: [ListingResponse] = []
    
    public init() {}
    
    public init(json: JSONDictionary) throws {
        listings = try decode(json, key: "listings")
    }
}
