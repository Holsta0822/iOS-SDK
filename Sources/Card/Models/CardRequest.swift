import Foundation

public struct CardRequest {

    /// The ID of the order to be approved
    public let orderID: String

    /// The card to be charged for this order
    public let card: Card

    /// Creates an instance of a card request
    /// - Parameters:
    ///   - orderID: The ID of the order to be approved
    ///   - card: The card to be charged for this order
    public init(orderID: String, card: Card) {
        self.orderID = orderID
        self.card = card
    }
}
