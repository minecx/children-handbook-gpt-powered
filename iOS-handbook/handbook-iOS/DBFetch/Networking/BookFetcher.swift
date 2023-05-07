//
//  BookFetcher.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 5/5/23.
//

import Foundation


class BookFetcher: ObservableObject {
    
    @Published var books = [Book]()
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = BookAPIService()) {
        self.service = service
        fetchAllBooks()
    }
    
    func fetchAllBooks() {
        
        isLoading = true
        errorMessage = nil
        
        let service = BookAPIService()
        let url = URL(string: "http://35.236.214.238/api/books/")
        service.fetchBooks(url: url) { [unowned self] result in
            DispatchQueue.main.sync {
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                case .success(let books):
                    self.books = books
                }
            }
        }
    }
    
    //MARK: preview helpers
    
    static func errorState() -> BookFetcher {
        let fetcher = BookFetcher()
        fetcher.errorMessage = APIerror.url(URLError.init(.notConnectedToInternet)).localizedDescription
        return fetcher
    }
    
    static func successState() -> BookFetcher {
        let fetcher = BookFetcher()
        fetcher.books = [Book.example1(), Book.example2()]
        
        return fetcher
    }
}
