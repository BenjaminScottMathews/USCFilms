//
//  ImageCarousel.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/10/21.
//

import Foundation
import SwiftUI
import Combine


struct ImageCarousel<Content: View>: View
{
    private var numberOfImages: Int
    private var content: Content

      @State private var currentIndex: Int = 0
      
      private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

      init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
          self.numberOfImages = numberOfImages
          self.content = content()
      }

      var body: some View {
          GeometryReader { geometry in
              HStack(spacing: 0) {
                self.content
              }
              .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
              .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
              .animation(.spring())
              .onReceive(self.timer) { _ in
                  
                  self.currentIndex = (self.currentIndex + 1) % 5
              }
          }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader { geometry in
                    ImageCarousel(numberOfImages: 3) {
                        Image("image_carousel_1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                        Image("image_carousel_2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                        Image("image_carousel_3")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                }.frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
            }
}
