//
//  ASearch.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/15/21.
//

import Foundation
import Kingfisher

public class ASearch: Identifiable, ObservableObject
{
    @Published var title: String
    @Published var rating: String
    @Published var poster: RemoteImage
    @Published var type: String
    @Published var date: String
    @Published public var id: String
    
    init()
    {
        title = ""
        rating = ""
        type = ""
        poster = RemoteImage(url: "https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg")
        date = ""
        id = ""
    }
    
    init (newTitle: String, newRating: String, newType: String, newPoster: String, newDate: String, newId: String)
    {
        title = newTitle
        rating = newRating
        type = newType
        poster = RemoteImage(url: newPoster)
        date = String(newDate.prefix(while: {$0 != "-"}))
        id = newId
    }
}
