#  LeanNetworkKit

URLSession-based framework for easy request scheduling and handling.

## Table of Contents
* [Requirements](#Requirements)
* [Usage](#Usage)
* [Author](#Author)

## Requirements
* iOS 11.0+
* Xcode 11+
* Swift 5.1+

## Usage

Start by instantiating a `HTTPClient`:
```swift
import LeanNetworkKit

let client = HTTPClient(urlSession: URLSession(...))
```

Next, create a request:
```swift
let request = Request(url: URL(string: "https://yoururl.com")!)
    .setTimeout(30)
    .addHeader(key: "Accept", val: "application/json")
    .addQueryItem(key: "page", val: "1")
    .decode(to: YourType.self)
```

To send your request, use the previously created client:
```swift
client.send(request)
    .onSuccess({ myType in
        print(myType)
    })
    .onFailure({ error in
        print(error.localizedDescription)
    })
```

If you want to observe your requests:
```swift
let client = HTTPClient(urlSession: URLSession(...))
    .observeRequests(requestWillStart: { (request) in
        print("Request will start: \(request)")
    }, requestDidSucceed: { (request, _) in
        print("Request did succeed: \(request)")
    }, requestDidFail: { (request, _) in
        print("Request did fail: \(request)")
    }, didCancelRequest: { (request) in
        print("Request was cancelled: \(request)")
    })
```

If you want to modify your requests before they are sent (e.g. inject authorization headers):
```swift
let client = HTTPClient(urlSession: URLSession(...))
    .modifyRequests({ (request) in
        request.addValue("some_token_goes_here", forHTTPHeaderField: "Authorization: Basic")
    })
```

### Adding data / payload to a request

If you want to set the body of the request:
```swift
let data = Data(...)
let request = Request(...)
    .setBody(data)
```

You can also do this with an `Encodable` object:
```swift
struct Body: Encodable {
    let userId: String
    let password: String
}
let body = Body(...)
let request = Request(...)
    .setBody(fromObject: body)
```

## Author

* [Gonzalo RH](https://github.com/dirtyhabits97)
