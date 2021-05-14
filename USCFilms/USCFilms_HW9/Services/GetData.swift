//
//  get_carousel.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/10/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine
import Kingfisher

public class GetData
{
    func get_carousel(reelType: String, completion: @escaping ([Media]?) -> Void)
    {
        var myMovies: [Media] = []
        AF.request("https://uscfilms.ue.r.appspot.com" + reelType, method:.get)
        .responseJSON
        { response in
            let json = JSON(response.data ?? {})
            if let curr_media = json.array
            {
                for m in curr_media
                {
                    let id = m["id"].int!
                    let title = m["title"].string!
                    let type = m["type"].string!
                    let poster = RemoteImage(url: m["poster"].string!)
                    let newMedia = Media(newId: id, newTitle: title, newPoster: poster, newType: type)
                    newMedia.setKFStr(str: m["poster"].string!)
                    myMovies.append(newMedia)
                }
                completion (myMovies)
            }
        }
    }
    
    
    func get_toppop(reelType: String, completion: @escaping ([Media]?) -> Void)
    {
        var myTop: [Media] = []
        AF.request("https://uscfilms.ue.r.appspot.com/mediaReel" + reelType, method:.get)
        .responseJSON
        { response in
            let json = JSON(response.data ?? {})
            if let curr_media = json.array
            {
                for m in curr_media
                {
                    let id = m["id"].int!
                    let title = m["title"].string!
                    let poster = RemoteImage(url: m["poster"].string!)
                    let type = m["mediaType"].string!
                    let newMedia = Media(newId: id, newTitle: title, newPoster: poster, newType: type)
                    newMedia.setKFStr(str: m["poster"].string!)
                    newMedia.setDate(year: m["date"].array!)
                    myTop.append(newMedia)
                }
                completion (myTop)
            }
        }
    }
}
