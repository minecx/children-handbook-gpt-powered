//
//  APIServiceProtocol.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import Foundation

protocol APIServiceProtocol {
    func fetchBooks(url: URL?, completion: @escaping(Result<[Book], APIerror>) -> Void)
}
