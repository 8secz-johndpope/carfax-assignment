import Foundation

public struct ListingResponse: JSONDeserializable {
    public internal(set) var id: String = ""
    public internal(set) var make: String = ""
    public internal(set) var model: String = ""
    public internal(set) var imagesResponse: ImagesResponse?
    public internal(set) var year: Int = 0
    public internal(set) var trim: String = ""
    public internal(set) var price: Double = 0
    public internal(set) var mileage: Double = 0
    public internal(set) var dealerResponse: DealerResponse
    
    public init(json: JSONDictionary) throws {
        id = try decode(json, key: "id")
        make = try decode(json, key: "make")
        model = try decode(json, key: "model")
        imagesResponse = try? decode(json, key: "images")
        year = try decode(json, key: "year")
        trim = try decode(json, key: "trim")
        price = try decode(json, key: "listPrice")
        mileage = try decode(json, key: "mileage")
        dealerResponse = try decode(json, key: "dealer")
    }
}
