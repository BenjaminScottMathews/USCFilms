//
//  MediaType.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/11/21.
//

import Foundation

public class MediaType
{
    func getType(onMovies: Bool) -> String {return onMovies ? "TV Shows" : "Movies"}
    func getType2(onMovies: Bool) -> String {return onMovies ? "Now Playing" : "Trending"}
}
