//
//  Identifo
//
//  Copyright (C) 2019 MadAppGang Pty Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public struct Context {
    
    public let apiURL: URL
    
    public let clientID: String
    public let secretKey: String

    public var deviceToken: String?
    public var accessToken: String?
    public var refreshToken: String?
    
    public init(apiURL: URL, clientID: String, secretKey: String) {
        self.apiURL = apiURL
        self.clientID = clientID
        self.secretKey = secretKey
    }

}

extension Context {
    
    func apiURL(path: String, query: [String: String?] = [:]) -> URL {
        var components = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)!
        components.path += path
        
        if !query.isEmpty {
            components.queryItems = []
            
            for (name, value) in query {
                let item = URLQueryItem(name: name, value: value)
                components.queryItems?.append(item)
            }
        }
        
        return components.url!
    }
    
}
