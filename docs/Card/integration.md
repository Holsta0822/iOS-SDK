---
title: Pay with Card Custom Integration
keywords: 
contentType: docs
productStatus: current
apiVersion: TODO
sdkVersion: TODO
---

# Pay with Card Custom Integration

Follow these steps to add Card payments.

1. [Know before you code](#know-before-you-code)
1. [Add Card Payments](#add-card-payments)
1. [Test and go live](#test-and-go-live)

## Know before you code

You will need to set up authorization to use the PayPal Payments SDK. 
Follow the steps in [Get Started](https://developer.paypal.com/api/rest/#link-getstarted) to create a client ID and generate an access token. 

You will need a server integration to create an order and capture the funds using [PayPal Orders v2 API](https://developer.paypal.com/docs/api/orders/v2). 
For initial setup, the `curl` commands below can be used in place of a server SDK.

## Add Card Payments

Accept card payments with PayPal Payments SDK using your own UI.

### 1. Add the Payments SDK  to your app

#### Swift Package Manager

In Xcode, add the [package dependency](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app) and enter https://github.com/paypal/iOS-SDK as the repository URL. Tick the checkboxes for the specific PayPal libraries you wish to include.

In your app's source code files, use the following import syntax to include PayPal's Card library:

```swift
import Card
```

#### CocoaPods

Include the PayPal pod in your `Podfile`.

```ruby
pod 'PayPal'
```

In your app's source code files, use the following import syntax to include PayPal's Card library:

```swift
import Card
```

### 2. Initiate the Payments SDK

Create a `CoreConfig` using your client ID from the PayPal Developer Portal:

```swift
let config = CoreConfig(clientID: "<CLIENT_ID>", environment: .sandbox)
```

Create a `CardClient` to approve an order with a Card payment method:

```swift
let cardClient = CardClient(config: config)
```

### 3. Create an order

When a user enters the payment flow, call `v2/checkout/orders` to create an order and obtain an order ID:

```bash
curl --location --request POST 'https://api.sandbox.paypal.com/v2/checkout/orders/' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <ACCESS_TOKEN>' \
--data-raw '{
    "intent": "<CAPTURE|AUTHORIZE>",
    "purchase_units": [
        {
            "amount": {
                "currency_code": "USD",
                "value": "5.00"
            }
        }
    ]
}'
```

The `id` field of the response contains the order ID to pass to your client.

### 4. Create a request containing the card payment details

Create a `Card` object containing the user's card details.

```Swift
let card = Card(
    number: "4111111111111111",
    expirationMonth: "01",
    expirationYear: "25",
    securityCode: "123",
    cardholderName: "Jane Smith",
    billingAddress: Address(
        addressLine1: "123 Main St.",
        addressLine2: "Apt. 1A",
        locality: "city",
        region: "IL",
        postalCode: "12345",
        countryCode: "US"
    )
)
```

Attach the card and the order ID from [step 3](#3-create-an-order) to a `CardRequest`.

```swift
let cardRequest = CardRequest(orderID: "<ORDER_ID>", card: card)
```

### 5. Approve the order using Payments SDK

Approve the order using your `CardClient`.

Call `CardClient#approveOrder` to approve the order, and then handle results:

```swift
cardClient.approveOrder(request: cardRequest) { result in
    switch result {
        case .success(let result):
            // order was successfully approved and is ready to be captured/authorized (see step 6)
        case .failure(let error):
            // handle the error by accessing `result.localizedDescription`
    }
}
```

### 6. Capture/authorize the order

If you receive a successful result in the client-side flow, you can then capture or authorize the order. 

Call `authorize` to place funds on hold:

```bash
curl --location --request POST 'https://api.sandbox.paypal.com/v2/checkout/orders/<ORDER_ID>/authorize' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <ACCESS_TOKEN>' \
--data-raw ''
```

Call `capture` to capture funds immediately:

```bash
curl --location --request POST 'https://api.sandbox.paypal.com/v2/checkout/orders/<ORDER_ID>/capture' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <ACCESS_TOKEN>' \
--data-raw ''
```

## Testing and Go Live

### 1. Test the Card integratoin

TODO - Do we have test card numbers merchants can test this with?

### 2. Go live with your integration

Follow [these instructions](https://developer.paypal.com/api/rest/production/) to prepare your integration to go live.

