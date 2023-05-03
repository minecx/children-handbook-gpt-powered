//
//  ChildrenBookFetcher.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import Foundation

class BreedFetcher: ObservableObject {
    
    @Published var breeds = [Breed]()
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    init() {
        fetchAllBreeds()
    }
    
    func fetchAllBreeds() {
        
        isLoading = true
        errorMessage = nil
        
        let service = APIService()
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")
        service.fetchBreeds(url: url) { [unowned self] result in
            DispatchQueue.main.sync {
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                case .success(let breeds):
                    self.breeds = breeds
                }
            }
        }
    }
    
    //MARK: preview helpers
    
    static func errorState() -> BreedFetcher {
        let fetcher = BreedFetcher()
        fetcher.errorMessage = APIerror.url(URLError.init(.notConnectedToInternet)).localizedDescription
        return fetcher
    }
    
    static func successState() -> BreedFetcher {
        let fetcher = BreedFetcher()
        fetcher.breeds = [Breed.example1(), Breed.example2()]
        
        return fetcher
    }
}
