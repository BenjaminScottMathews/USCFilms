//
//  Detail.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/14/21.
//

import Foundation
import Kingfisher

public class Detail
{
    var id: String
    var trailer: String
    var title: String
    var date: String
    var genres: [String]
    var rating: String
    var description: String
    var cast_and_crew: [Person]
    var reviews: [Review]
    var poster: RemoteImage
    var posterStr: String = ""
    
    init()
    {
        id = ""
        trailer = ""
        title = ""
        date = ""
        genres = [""]
        rating = ""
        description = ""
        poster = RemoteImage(url: "https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg")
        cast_and_crew = [Person()]
        reviews = [Review()]
    }
    
    init(newID: String, newTrailer: String, newTitle: String, newDate: String, newGenres: [String], newRating: String, newDescription: String, newCast: [Person], newReviews: [Review], newPoster: RemoteImage)
    {
        id = newID
        trailer = newTrailer
        title = newTitle
        date = newDate
        genres = newGenres
        rating = newRating
        description = newDescription
        cast_and_crew = newCast
        reviews = newReviews
        poster = newPoster
    }
    
}
