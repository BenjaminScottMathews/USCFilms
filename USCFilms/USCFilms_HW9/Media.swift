//
//  Media.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/11/21.
//

import Foundation
import Kingfisher
import SwiftyJSON
import Combine

public class Media: Identifiable, ObservableObject
{
    @Published var title: String
    @Published public var id: Int
    @Published var poster: RemoteImage
    @Published var date: String
    @Published var type: String
    
    var kf_str = "https://uscfilms.ue.r.appspot.com/assets/movie_placeholder.png"
    
    var watchlistStr = "Add to watchlist"
    var watchlistImg = "bookmark"
    
    init()
    {
        self.title = ""
        self.id = 0
        self.poster = RemoteImage(url: kf_str)
        self.date = "2000"
        self.type = "Movie"
    }
    
    init (newId: Int, newTitle: String, newPoster: RemoteImage, newType: String)
    {
        self.id = newId
        self.title = newTitle
        self.poster = newPoster
        self.date = "2000"
        self.type = newType
    }
    
    func setDate(year: [JSON])
    {
        self.date = year[0].string ?? "2000"
    }
    
    func setKFStr(str: String)
    {
        kf_str = str
    }
    
}
