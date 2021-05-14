//
//  DetailService.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/14/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine
import Kingfisher

public class DetailService
{
    func get_details(route: String, completion: @escaping (Detail?) -> Void)
    {
        AF.request("https://uscfilms.ue.r.appspot.com/details" + route, method:.get)
        .responseJSON
        { response in
            
            let json = JSON(response.data ?? {})
            //Get Cast Info
            AF.request("https://uscfilms.ue.r.appspot.com/cast" + route, method:.get)
            .responseJSON
            { cast in
                
                let jsonCast = JSON(cast.data ?? {}).array ?? []
                //Get Cast Info
                AF.request("https://uscfilms.ue.r.appspot.com/reviews" + route, method:.get)
                .responseJSON
                { reviews in
            
                    let jsonReviews = JSON(reviews.data ?? {}).array ?? []
                    let id = json["id"].string ?? ""
                    let vidType = json["type"].string ?? ""
                    var yt = ""
                    if (vidType == "Trailer")
                    {
                        yt = json["vid_key"].string ?? "nA91iZXpXp8"
                    }
                    let title = json["title"].string ?? "None"
                    let date = self.calcDate(jsonDate: json["date"].array!)
                    let genres = self.calcGenres(jsonGenres: json["genres"].array!)
                    let rating = json["vote"].string ?? "0.0"
                    let description = json["overview"].string ?? "No Description"
                    print (json["poster"].string!)
                    let poster = RemoteImage(url: json["poster"].string!)
                    
                    
                    var cast: [Person] = []
                    var reviews: [Review] = []
                    for member in jsonCast
                    {
                        cast.append(Person(newName: member["name"].string ?? "No Name", newPic: RemoteImage(url: member["headshot"].string!)))
                    }
                    for review in jsonReviews
                    {
                        reviews.append(Review(newUsername: review["author"].string!, newDate: review["date"].string!, newRating: review["rating"].string!, newReview: review["content"].string!))
                    }
    
                    let myDetail = Detail(newID: id, newTrailer: yt, newTitle: title, newDate: date, newGenres: genres, newRating: rating, newDescription: description, newCast: cast, newReviews: reviews, newPoster: poster)
                    
                    myDetail.posterStr = json["poster"].string!
                    completion(myDetail)
                }
            }
        }
    }
    
    func get_recs(route: String, completion: @escaping ([Media]?) -> Void)
    {
        var myRecs: [Media] = []
        AF.request("https://uscfilms.ue.r.appspot.com/individual" + route, method:.get)
        .responseJSON
        { recs in
            let json = JSON(recs.data ?? {})
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
                    myRecs.append(newMedia)
                }
                completion (myRecs)
            }
        }
    }
    
    
    private func calcDate(jsonDate: [JSON]) -> String { return jsonDate[0].string ?? "3500" }
    
    private func calcGenres(jsonGenres: [JSON]) -> [String]
    {
        var convertedGenres: [String] = []
        
        for g in jsonGenres { convertedGenres.append(g.string!) }
        
        return convertedGenres
    }
}
