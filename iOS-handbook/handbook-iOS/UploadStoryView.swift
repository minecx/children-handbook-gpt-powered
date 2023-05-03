//
//  UploadStoryView.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import SwiftUI

struct UploadStoryView: View {
    
    @State private var bookName: String = ""
    @State private var storyBody: String = ""
    @State private var coverURL: String = ""
    @State private var author: String = ""
    @State private var genre: String = ""
    @State private var description: String = ""
    
    var body: some View {
        GeometryReader { geo in
            
            ScrollView {
                VStack (alignment: .leading) {
                    VStack{
                        Text("Title *")
                            .font(.system(size: 16, weight: .bold))
                        TextField("Give your story a name", text: $bookName)
                            .font(.system(size: 15, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 34).stroke(Color.black))
                        Text("Description *")
                            .font(.system(size: 16, weight: .bold))
                        TextField("Descrip here", text: $description)
                            .font(.system(size: 15, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 34).stroke(Color.black))
                        Text("Story *")
                            .font(.system(size: 16, weight: .bold))
                        TextEditor(text: $storyBody)
                            .font(.system(size: 15, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 34).stroke(Color.black))
                            .font(.system(size: 15, weight: .medium))
                            .disableAutocorrection(true)
                            .padding()
                        //                    .background(.white).opacity(0.7)
                            .frame(height: geo.size.height * 0.3)
                        Text("Genre *")
                            .font(.system(size: 16, weight: .bold))
                        TextField("Genre here", text: $genre)
                            .font(.system(size: 15, weight: .medium))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 34).stroke(Color.black))
                    }
                    Text("Cover *")
                        .font(.system(size: 16, weight: .bold))
                    TextField("http://", text: $coverURL)
                        .font(.system(size: 15, weight: .medium))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 34).stroke(Color.black))
                    
                    Text("Creator *")
                        .font(.system(size: 16, weight: .bold))
                    TextField("Enter here", text: $author)
                        .font(.system(size: 15, weight: .medium))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 34).stroke(Color.black))
                    
                    Spacer()
                    
                    Button{
                        //TODO:
                    }label:{
                        Text("Upload")
                            .bold()
                            .frame(height: 55)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 18))
                            .foregroundColor(Color.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("BubbleColor1"), Color("BubbleColor3")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom)
                }
                .background(MovingBubblesView())
            }
        }
        .padding()
    }
}

struct UploadStoryView_Previews: PreviewProvider {
    static var previews: some View {
        UploadStoryView()
    }
}
