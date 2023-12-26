# Moyasar iOS SDK

## Overview

This guide will walk you through a straightforward solution to accept payments within your iOS application. The iOS SDK is a small framework built with **SwiftUI** that allows you to quickly and safely integrate Moyasar payments within your **SwiftUI** or **UIKit** apps.

## Installing CocoaPods

Before you can add the library to your project, you need to install CocoaPods on your macOS using the following command:

```shell
brew install cocoapods
```

Or as a Ruby gem

```shell
gem install cocoapods
```

## Add the Dependency

If you haven't already added CocoaPods to your project, initialize it with:

```shell
pod init
```

Now add the following pod to your `Podfile`:

```ruby
pod 'MoyasarSdk', git: 'https://github.com/moyasar/moyasar-ios-pod.git'
```

:::hint{type="info"}
Make sure to add `use_frameworks!`
:::

## Configuring a Payment Request

We need to prepare a `PaymentRequest` object:

```swift
let paymentRequest = PaymentRequest(
    apiKey: "pk_live_1234567",
    amount: 1000,
    currency: "SAR",
    description: "Flat White",
    metadata: ["order_id": "ios_order_3214124"],
    manual: false,
    saveCard: false
)
```

:::hint{type="info"}
Don't forget to import `MoyasarSdk`.
:::

## Apple Pay Payments

You can follow [Offering Apple Pay in Your App](https://developer.apple.com/documentation/passkit/apple_pay/offering_apple_pay_in_your_app) to implement Apple Pay within your app.

When the user authorizes the payment using Face ID or Touch ID on their iOS device, the `didAuthorizePayment` event will be dispatched. In this step, you must pass the `token` to `ApplePayService` found within the `PKPayment` object. Here is an example:

```swift
let payment: PKPayment = // Payment object we got in the didAuthorizePayment event

let service = ApplePayService(apiKey: "pk_live_1234567") // From MoyasarSdk
service.authorizePayment(request: paymentRequest, token: payment.token) {result in
    switch (result) {
    case .success(let payment):
        handleCompletedPaymentResult(payment)
        break
    case .error(let error):
        handlePaymentError(error)
        break
    @unknown default:
        // Handle any future cases
        break
    }
}

func handleCompletedPaymentResult(_ payment: ApiPayment) {
        // ...
    }
    
func handlePaymentError(_ error: MoyasarError) {
        // Handle all MoyasarError enum cases
    }

```

:::hint{type="info"}
Don't forget to import `PassKit`.
:::

:::hint{type="info"}
An error will be printed if the API key format is incorrect.
:::

## SwiftUI Credit Card Payments

The SDK provides a SwiftUI view called `CreditCardView` that allows you to easily create a credit card form.

We can add the `CreditCardView` to our view as follows:

```swift
struct ContentView: View {
    func handlePaymentResult(_ result: PaymentResult) {
        // ...
    }
    
    func handleCompletedPaymentResult(_ payment: ApiPayment) {
        // ...
    }
    
    func handlePaymentError(_ error: MoyasarError) {
        // Handle all MoyasarError enum cases
    }

    var body: some View {
        CreditCardView(
            request: paymentRequest,
            callback: handlePaymentResult
        )
    }
}
```

## UIKit Credit Card Payments

If you are using UIKit you will need to create a wrapper to host the SwiftUI `CreditCardView` view:

```swift
    func makeCreditCardView() {
        let creditCardView = CreditCardView(
            request: paymentRequest,
            callback: handlePaymentResult
            )
        
        let creditCardHostingController = UIHostingController(rootView: creditCardView)
        creditCardHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(creditCardHostingController)
        view.addSubview(creditCardHostingController.view)
        creditCardHostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            creditCardHostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            creditCardHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            creditCardHostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            creditCardHostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    
    func handlePaymentResult(_ result: PaymentResult) {
        // ...
    }
    
    func handleCompletedPaymentResult(_ payment: ApiPayment) {
        // ...
    }
    
    func handlePaymentError(_ error: MoyasarError) {
        // Handle all MoyasarError enum cases
    }
```

:::hint{type="info"}
Don't forget to import `SwiftUI`.
:::

* ![IOS SDK dark ar](assets/Images/ar-dark.png) ![IOS SDK light en](assets/Images/en-light.png)

## Handling Credit Card Payment Result

Now, we can handle the Credit Card payment result as follows:

```swift
func handlePaymentResult(result: PaymentResult) {
    switch (result) {
    case .completed(let payment):
        handleCompletedPaymentResult(payment)
        break
    case .failed(let error):
        handlePaymentError(error)
        break
    case .canceled:
        // Handle cancel Result
        break
    @unknown default:
        // Handle any future cases
         break
    }
}

func handleCompletedPaymentResult(_ payment: ApiPayment) {
        // ...
}
    
func handlePaymentError(_ error: MoyasarError) {
        // Handle all MoyasarError enum cases
}
```

:::hint{type="info"}
If the payment failed during the 3DS authentication process, the `PaymentResult` will be `.failed` with the `MoyasarError` enum case beggining with `webview...`. You should fetch the payment as per [this documentation](https://docs.moyasar.com/fetch-payment) and check it's status as it might be `paid`.
:::

:::hint{type="warning"}
Make sure to dismiss the webview screen after getting the result.
:::

## Handling Completed Payment Result

The payment status could be `paid`, `failed` or other statuses, we need to handle this:

```swift
func handleCompletedPaymentResult(_ payment: ApiPayment) {
    switch payment.status {
    case .paid:
        // Handle paid!
        break
    default:
        // Handle other statuses like failed
    }
}
```

:::hint{type="info"}
'Completed' payment doesn't necessarily mean that the payment is successful. It means that the payment process has been completed successfully.
You need to check the payment status to make sure that the payment is successful.
:::

:::hint{type="info"}
You can find payment statuses here:
[Payment Statuses](#payment-statuses)
:::

## Customizing Credit Card View

Use the `create` method in the `PaymentService` class like this:

```swift
let paymentService = PaymentService(apiKey: "pk_live_1234567")

let source = ApiCreditCardSource(
    name: "John Doe",
    number: "4111111111111111",
    month: "09",
    year: "25",
    cvc: "456",
    manual: "false",
    saveCard: "false"
)

let paymentRequest = ApiPaymentRequest(
    amount: 1000,
    currency: "SAR",
    description: "Flat White",
    callbackUrl: "https://sdk.moyasar.com/return",
    source: ApiPaymentSource.creditCard(source),
    metadata: ["sdk": "ios", "order_id": "ios_order_3214124"]
)

do {
    try paymentService.create(paymentRequest, handler: {result in
        DispatchQueue.main.async {
            switch (result) {
            case .success(let payment):
                startPaymentAuthProcess(payment)
                break;
            case .error(let error):
                handlePaymentError(error)
                break;
            }
         }
    })
} catch {
    // Handle error
}

func startPaymentAuthProcess(_ payment: ApiPayment) {
    // ...
}

func handlePaymentError(_ error: MoyasarError) {
    // Handle all MoyasarError enum cases
}
```

:::hint{type="info"}
Make sure to add the 'sdk' field with the value of 'ios' in `ApiPaymentRequest` metadata dictionary field. (Only when creating a custom UI)
:::

Now when the payment is initiated successfully you need to initialize the 3DS web view as follows:

```swift
func startPaymentAuthProcess(_ payment: ApiPayment) {
    guard payment.isInitiated() else {
        // Handle case
        // Payment status could be paid, failed, authorized, etc...
        return
    }
        
    guard case let .creditCard(source) = payment.source else {
        // Handle error
        return
    }
        
    guard let transactionUrl = source.transactionUrl, let url = URL(string: transactionUrl) else {
        // Handle error
        return
    }
        
    showWebView(url)
}

func showWebView(_ url: URL) {
    // Initialize the 3DS web view
}
```

:::hint{type="info"}
You can view the full example here:
<https://github.com/moyasar/moyasar-ios-sdk/tree/master/SwiftUiDemo/SwiftUiDemo/Custom%20View>
:::

:::hint{type="info"}
You can find payment statuses here:
[Payment Statuses](#payment-statuses)
:::

## Objective-C Integration

Setup a Swift file for handling payments as described in:

<!-- no toc -->
* [Configuring a Payment Request](#configuring-a-payment-request)
* [Apple Pay Payments](#apple-pay-payments)
* [UIKit Credit Card Payments](#uikit-credit-card-payments)
* [Handling Credit Card Payment Result](#handling-credit-card-payment-result)
* [Handling Completed Payment Result](#handling-completed-payment-result)

After that you can initialize the Swift payments class when processing payments.

Learn more about integrating Swift files in Objective-C apps:
<https://developer.apple.com/documentation/swift/importing-swift-into-objective-c>

## Testing

### Credit Cards

Moyasar provides a sandbox environment for testing credit card payments without charging any real money. This allows you to test your integration and ensure that everything is working correctly before going live with actual payments. Learn more about our testing cards [here](https://docs.moyasar.com/testing-cards)

### Apple Pay

Testing using a simulator will not work! Learn more about Apple Pay testing [here](https://docs.moyasar.com/apple-pay-testing).

## Migration Guide

### From `0.4` to `1.0`

This upgrade changes the following:

#### Setting the API key

```diff
-   try! Moyasar.setApiKey("pk_live_1234567")

PaymentRequest(
+   apiKey: "pk_live_1234567",
    amount: 1000,
    currency: "SAR",
    description: "Flat White",
    metadata: ["order_id": "ios_order_3214124"],
    manual: false,
    saveCard: false
)

ApplePayService(
+   apiKey: "pk_live_1234567"
)         
```
  
#### Handling Payment Statuses

```diff
    switch payment.status {
-   case "paid":
+   case .paid:
}
```

* Also, now you can handle the errors based on `MoyasarError` enum.

## Payment Statuses

* <https://docs.moyasar.com/payment-status-reference>

## APIs Documentation

* <https://moyasar.github.io/moyasar-ios-sdk/documentation/moyasarsdk>

## Demo Examples

* <https://github.com/moyasar/moyasar-ios-sdk>
