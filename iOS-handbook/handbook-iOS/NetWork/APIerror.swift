//
//  APIerror.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import Foundation

enum APIerror: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        //info for user feedback
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong"
        case .badResponse(_):
            return  "Sorry, the connection to our server failed"
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong"
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
        case .badURL:
            return "Bad URL"
        case .parsing(let error):
            return "Parsing error \(error?.localizedDescription ?? "")"
        case .unknown:
            return "Unknown error"
        case .badResponse(let statusCode):
            return "Bad response with status code: \(statusCode)"
        case .url(let error):
            return error?.localizedDescription ?? "URL session error"
        }
    }

}
