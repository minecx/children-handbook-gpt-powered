//
//  APIservice.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import Foundation

struct APIservice {
    func fetch<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T, APIerror>) -> Void) {
        guard let url = url else {
            let error = APIerror.badURL
            completion(Result.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIerror.url(error)))
            } else if let response = response as? HTTPURLResponse,
                      !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIerror.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completion(Result.success(result))
                } catch {
                    completion(Result.failure(APIerror.parsing(error as? DecodingError)))
                }
            }
        }
        task.resume()
    }
    
    
    func fetchChildrenBooks(url: URL?, completion: @escaping(Result<[ChildrenBook], APIerror>) -> Void) {
        //TODO: adjust url to api call
        guard let url = url else {
            let error = APIerror.badURL
            completion(Result.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIerror.url(error)))
            } else if let response = response as? HTTPURLResponse,
                      !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIerror.badResponse(statusCode: response.statusCode)))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let books = try decoder.decode([ChildrenBook].self, from: data)
                    completion(Result.success(books))
                } catch {
                    completion(Result.failure(APIerror.parsing(error as? DecodingError)))
                }
            }
        }
        task.resume()
    }
}
