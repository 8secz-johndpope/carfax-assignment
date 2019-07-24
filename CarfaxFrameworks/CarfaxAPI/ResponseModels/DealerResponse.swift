import Foundation

public struct DealerResponse: JSONDeserializable {
    public internal(set) var addressFirstLine: String = ""
    public internal(set) var state: String = ""
    public internal(set) var city: String = ""
    public internal(set) var phone: String?
    public internal(set) var averageRating: Double = 0

    public init() {}
    
    public init(json: JSONDictionary) throws {
        addressFirstLine = try decode(json, key: "address")
        state = try decode(json, key: "state")
        city = try decode(json, key: "city")
        phone = try? decode(json, key: "phone")
        averageRating = try decode(json, key: "dealerAverageRating")
    }
}
