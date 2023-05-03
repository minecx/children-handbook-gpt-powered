//
//  BreedDetailView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/29/23.
//

import SwiftUI

struct BreedDetailView: View {
    let breed: Breed
    let imageSize: CGFloat = 300
    
    var body: some View {
        ScrollView {
            if breed.image?.url != nil {
                AsyncImage(url: URL(string: breed.image!.url!)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                    } else if phase.error != nil {
                        Text(phase.error?.localizedDescription ?? "error")
                            .foregroundColor(Color.pink)
                            .frame(width: imageSize, height: imageSize)
                    } else {
                        ProgressView()
                            .frame(width: imageSize, height: imageSize)
                    }
                }
            } else {
                Color.gray.frame(width: imageSize, height: imageSize)
            }
            VStack(alignment: .leading, spacing: 5){
                Text(breed.name)
                    .font(.headline)
                Text(breed.temperament)
                    .font(.footnote)
                Text(breed.breedExplaination)
                if breed.isHairless {
                    Text("hairless")
                }
                HStack{
                    Text("Energy Level")
                    Spacer()
                    ForEach(1..<6) { id in
                        Image(systemName: "star.fill")
                            .foregroundColor(breed.energyLevel > id ? Color.accentColor : Color.gray )
                    }
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BreedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetailView(breed: Breed.example1())
    }
}
