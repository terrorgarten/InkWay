//
//  DesignDetail.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation
import SwiftUI
import WrappingHStack

struct DesignDetailView: View {
    @StateObject var viewModel: DesignDetailViewModel
    @State var liked: Bool = false
    
    var body: some View {
        VStack {
            if let desing = viewModel.design {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack(alignment: .center) {
                            ZStack(alignment: .topLeading) {
                                AsyncImage(url: URL(string: desing.imageURL)){
                                    image in image.resizable()
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: 400, height: 400)
                                }
                                .frame(height: 400)

                            }
                        
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Purr-fect Scratch")
                                                .font(.system(size: 25))
                                            Spacer()
                                            HStack {
                                                Button(action: {
                                                    self.liked = !self.liked
                                                    viewModel.handleLikeAction(isLiked: liked)
                                                }
                                                ){
                                                    Image (systemName: liked ? "heart.fill" : "heart")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(liked ? Color.red : Color.gray)
                                                    .padding(5)
                                                }
                                            }
                                        }
                                        Text("Estimated price: 20$")
                                            .font(.system(size: 15))
                                        
                                    }
                                    Spacer()
                                }
                                
                                WrappingHStack(desing.tags, id: \.self) { tag in
                                    IWTag(text: tag.text)
                                        .padding(.vertical, 2)
                                }
                                .padding(.bottom, 5)
                                .padding(.horizontal, 5)
                               
                                VStack(alignment: .leading) {
                                    Text("Artist:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                    HStack(alignment: .top) {
                                        AsyncImage(url: URL(string: "https://www.mensjournal.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_1280/MTk2MTM2NTcwNDMxMjg0NzQx/man-taking-selfie.webp")){ image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(100)
                                        } placeholder: {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                                .frame(width: 70, height: 70)
                                        }
                                        .frame(height: 70)
                                        Text("YakuzaCustoms")
                                            .font(.system(size: 20))
                                    }
                                    Text("Created by YakuzaCustoms, a highly skilled and experienced tattoo artist known for their meticulous attention to detail and ability to bring their clients' visions to life. With a passion for both artistry and craftsmanship, YakuzaCustoms approaches each tattoo with creativity, professionalism, and a commitment to exceeding expectations.")
                                        .font(.system(size: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                            
                                    Text("Description:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .padding(.top)
                                    Text("The centerpiece of the tattoo is a charmingly realistic depiction of a cat's paw with extended claws, delicately poised mid-scratch. The paw features intricate details, including soft fur textures and gently curved claws, creating a sense of depth and realism. Positioned alongside the paw is a stylized depiction of a small wound, complete with meticulously rendered droplets of 'blood' ink, adding a touch of drama and authenticity to the design.")
                                        .font(.system(size: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.top)
                                .lineLimit(nil)
                            }.padding(.horizontal)
                        }
                        .padding(.bottom, 100)
                    }
                    
                    IWPrimaryButton(title: String(localized: "Book"), color: Color.accentColor, action: {})
                        .frame(maxWidth: .infinity)
                }
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("Post detail")
        .onAppear {
            viewModel.fetchDesign()
        }
    }
    
}
