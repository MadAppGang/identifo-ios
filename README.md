# Identifo iOS

[![Swift](https://img.shields.io/badge/Swift-5.0+-Orange?style=flat-square)](https://img.shields.io/badge/Swift-5.0+-Orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)

Identifo iOS is an open library that allows you instantly and easily integrate the [Identifo](https://github.com/MadAppGang/identifo) authentication framework in your apps.


## Installation

### SPM
1) Head to Xcode -> File -> Swift Packages -> Add Package Dependency...
2) Paste this link to the search bar: https://github.com/MadAppGang/identifo-ios
3) Proceed with the installation

### CocoaPods
```ruby
pod 'identifo-ios', '~> 1.0.0'
```

### Carthage
```ogdl
github "MadAppGang/identifo-ios" "1.0.0"
```


## Setup
Don't forget to import the library
```swift
import Identifo
```

Setup IdentifoManager using Context. 
Context needs 3 values to initialize: 
⋅⋅* __apiURL__ (URL to Identifo on your backend)
⋅⋅* __clientID__ (String - application access identifier defined on your backend)
⋅⋅* __secretKey__ (String - HMAC shared secret key, also defined on your backend)

```swift
class AuthManager {
    private var identifo: IdentifoManager!
    
    init() {
        setupIdentifo()
    }

    private func setupIdentifo() {
        let context = Context(apiURL: URL(string: SecretKey.apiURL)!,
                              clientID: SecretKey.clientID,
                              secretKey: SecretKey.secretKey)
        identifo = IdentifoManager(context: context)
    }
}
```
We recommend storing keys and IDs in the file ignored by the version control system or encrypting this file using [__git-secret__](https://git-secret.io)


## Usage
Here's how you can use Identifo functions in your implementation:
```swift
    func loginWith(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        identifo.loginWith(username: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let authInfo):
                guard let accessToken = authInfo.accessToken else {
                    completion(.failure(AuthError.noToken))
                    return
                }
                
                // Save access token to form url requests with it later. 
                // The best option for such storage is Apples Keychain Services
                self.saveToken(accessToken)
                
                decodeUserIDFrom(authInfo) { [weak self] result in
                    ...
                    // when you have decoded userID you can use it to request user entity from your server
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
```

You would need to decode your user identifier from AuthInfo that you receive on a successful authentication request. 
For that, you can use auth0's [JWTDecode library](https://github.com/auth0/JWTDecode.swift)

```swift
    import JWTDecode
    ...

    typealias UserID = String

    private func decodeUserIDFrom(_ authInfo: AuthInfo, completion: @escaping (Result<UserID, Error>) -> Void) {
        do {
            let jwt = try decode(jwt: authInfo.accessToken ?? "")
            guard let userID = jwt.subject else {
                completion(.failure(AuthError.noSubjectInToken))
                return
            }
            completion(.success(userID))
        } catch let error {
            completion(.failure(error))
        }
    }
```

## Forming network requests with the access token
When you've successfully authenticated your user and saved their access token you can use it to form network requests.
Here's one way how you can do it:
```swift
    private func yourRequest() {
        // retrive accessToken from where you've saved it
        let accessToken = keychainService.accessToken()

        var request = URLRequest(url: URL(string: "usersDataPoint")!)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
```

## Available functions
```swift
func registerWith(username: String, password: String, completion: @escaping (Result<AuthInfo, Error>) -> Void)
func loginWith(username: String, password: String, completion: @escaping (Result<AuthInfo, Error>) -> Void)
func requestPhoneCode(phoneNumber: String, completion: @escaping (Result<IdentifoSuccess, Error>) -> Void)
func loginWith(phoneNumber: String, verificationCode: String, completion: @escaping (Result<AuthInfo, Error>) -> Void)
// Federated login utilizes login options provided by Apple, Google, Facebook and Twitter
federatedLogin(provider: FederatedProvider, authorizationCode: String, completion: @escaping (Result<AuthInfo, Error>) -> Void)
func deanonymizeUser(completion: @escaping (Result<IdentifoSuccess, Error>) -> Void)
func resetPassword(email: String, completion: @escaping (Result<IdentifoSuccess, Error>) -> Void)
func renewAccessToken(completion: @escaping (Result<IdentifoSuccess, Error>) -> Void)
func logout(completion: @escaping (Result<Void, Error>) -> Void)
```

## License

Identifo for iOS is released under the MIT license. See [LICENSE](https://github.com/MadAppGang/identifo-ios/blob/master/LICENSE) for details.
