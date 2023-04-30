//
//  BreedListView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/29/23.
//

import SwiftUI

struct BreedListView: View {
    
    let breeds: [Breed]
    
    var body: some View {
        VStack{
            NavigationView {
                List {
                    ForEach(breeds) { breed in
                        NavigationLink {
                            BreedDetailView(breed: breed)
                        } label: {
                            BreedRow(breed: breed)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Find your Perfect Cat")
            }
        }
    }
}

struct BreedListView_Previews: PreviewProvider {
    static var previews: some View {
        BreedListView(breeds: [Breed.example1(), Breed.example2()])
    }
}
