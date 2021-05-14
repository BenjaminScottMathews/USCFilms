//
//  SearchService.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/15/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

public class Search
{
    func get_search(keyword: String, completion: @escaping ([ASearch]?) -> Void)
    {
        //var mySearch: [SearchMedia] = []
        AF.request("https://uscfilms.ue.r.appspot.com/typeahead/" + keyword, method:.get)
        .responseJSON
        { response in
            let json = (JSON(response.data ?? [])).array ?? []
            var mySearches: [ASearch] = []
            
            for j in json
            {
                let title = j["title"].string ?? "No Title Found"
                let rating = j["rating"].string ?? "0.0"
                let type = j["mediaType"].string ?? "Movie"
                let poster = j["poster"].string ?? "None"
                let date = j["date"].string ?? "3035"
                let id = j["id"].string ?? "0"
                if (poster == "None") { continue }
                mySearches.append(ASearch(newTitle: title, newRating: rating, newType: type, newPoster: poster, newDate: date, newId: id))
                //self.list.addToSearch(item: ASearch(newTitle: title, newRating: rating, newType: type, newPoster: poster))
            }
            
            completion(mySearches)
        }
    }
}
