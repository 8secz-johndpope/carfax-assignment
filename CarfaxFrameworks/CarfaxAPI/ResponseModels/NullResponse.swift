import Foundation

public struct NullResponse: JSONDeserializable {
    public init(json: JSONDictionary) throws {}
    public init(data: Data) throws {}
}
