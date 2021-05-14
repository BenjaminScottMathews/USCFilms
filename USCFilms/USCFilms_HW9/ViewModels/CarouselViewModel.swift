//
//  CarouselViewModel.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/11/21.
//

import Foundation
import SwiftUI
import Combine

class CarouselViewModel: ObservableObject
{
    @State var myMedia: [String] = ["SplashScreen"]
    
    init()
    {
        fetchMedia()
    }
    
    
    
    private func fetchMedia()
    {
        GetData().get_carousel {result in
            print (result![0])
            self.myMedia = /*result ??*/ ["NoNo"]}
    }

}
