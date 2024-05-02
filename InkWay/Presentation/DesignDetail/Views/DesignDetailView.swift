//
//  DesignDetail.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation
import SwiftUI

struct DesignDetailView: View {
    @StateObject var viewModel = DesignDetailViewModel()
    let post: PostModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .center) {
                    ZStack(alignment: .topLeading) {
                        AsyncImage(url: URL(string: post.imageURL)){
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
                                Text("Purr-fect Scratch")
                                    .font(.system(size: 25))
                                Text("Estimated price: 20$")
                                    .font(.system(size: 15))
                                
                            }
                            Spacer()
                        }
                       
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
                            Text("Ink and Color:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .padding(.top)
                            HStack {
                                Circle()
                                                .fill(Color.red)
                                                .frame(width: 60, height: 60)
                                                .shadow(radius: 10)
                                Circle()
                                                .fill(Color.black)
                                                .frame(width: 60, height: 60)
                                                .shadow(radius: 10)
                            }
                            Text("The Whisker Wound tattoo is expertly rendered using a combination of black and gray ink, masterfully shaded to create depth and dimensionality. The use of subtle gradients and highlights brings the scene to life, lending a sense of movement and realism to the tattoo. The addition of carefully applied red ink accents adds a pop of color to the wound, enhancing its visual impact without overwhelming the overall composition.")
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
        .navigationTitle("Post detail")
    }
    
}
