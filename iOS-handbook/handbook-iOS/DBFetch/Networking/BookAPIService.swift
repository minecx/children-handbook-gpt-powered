//
//  APIService.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import Foundation
import SwiftUI

struct BookAPIService: APIServiceProtocol {
    
    func fetch<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T,APIerror>) -> Void) {
        guard let url = url else {
            let error = APIerror.badURL
            completion(Result.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIerror.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIerror.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completion(Result.success(result))
                }catch {
                    completion(Result.failure(APIerror.parsing(error as? DecodingError)))
                }

            }
        }
        task.resume()
    }
    
    func fetchBooks(url: URL?, completion: @escaping(Result<[Book], APIerror>) -> Void) {
        guard let url = url else {
            let error  = APIerror.badURL
            completion(Result.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error as? URLError {
                completion(Result.failure(APIerror.url(error)))
            } else if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIerror.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                        print(prettyPrintedJson)
                    }
                } catch {
                    print("Error while printing JSON: \(error)")
                }
                let decoder = JSONDecoder()
                do {
                    let books = try decoder.decode([Book].self, from: data)
                    completion(Result.success(books))
                } catch {
                    completion(Result.failure(APIerror.parsing(error as? DecodingError)))
                }
            }
        }
        task.resume()
    }
}
