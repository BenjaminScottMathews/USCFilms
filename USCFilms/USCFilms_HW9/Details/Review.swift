//
//  Review.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/14/21.
//

import Foundation

public class Review: Identifiable
{
    var username: String
    var date: String
    var rating: String
    var review: String
    
    init ()
    {
        username = ""
        date = ""
        rating = ""
        review = ""
    }
    
    init (newUsername: String, newDate: String, newRating: String, newReview: String)
    {
        username = newUsername
        date = newDate
        rating = newRating
        review = newReview.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
