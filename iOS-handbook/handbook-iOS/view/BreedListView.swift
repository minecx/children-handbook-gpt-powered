//
//  BreedListView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/29/23.
//

import SwiftUI

struct BreedListView: View {
    
    let breeds: [Breed]
    @State private var searchText: String = ""
    
    var filteredBreeds: [Breed] {
        if searchText.count == 0 {
            return breeds
        } else {
            return breeds.filter { $0.name.contains(searchText)}
        }
    }
    
    var body: some View {
        VStack{
            NavigationView {
                List {
                    ForEach(filteredBreeds) { breed in
                        NavigationLink {
                            BreedDetailView(breed: breed)
                        } label: {
                            BreedRow(breed: breed)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Find your Perfect Cat")
                .searchable(text: $searchText)
            }
        }
    }
}

struct BreedListView_Previews: PreviewProvider {
    static var previews: some View {
        BreedListView(breeds: [Breed.example1(), Breed.example2()])
    }
}
