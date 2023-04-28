//
//  ChildrenBookFetcher.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import Foundation

class ChildrenBookFetcher: ObservableObject {
    @Published var books = [ChildrenBook]()
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {
        fetchAllChildrenBooks()
    }
    
    func fetchAllChildrenBooks() {
        isLoading = true
        errorMessage = nil
        let service = APIservice()
        let url = URL(string: "https://axxx.com/resources/books")
        service.fetchChildrenBooks(url: url) { [unowned self] result in
            self.isLoading = false
            
            switch result {
            case .failure(let apiError):
                self.errorMessage = apiError.localizedDescription
                print(apiError)
            case .success(let books):
                self.books = books
            }
        }
    }
}
