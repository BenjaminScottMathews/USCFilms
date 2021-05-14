//
//  WatchList.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/12/21.
//

import Foundation
import Kingfisher

class WatchList: ObservableObject
{
    
    @Published var watchlist: [Media] = []
    
    @Published var currentDrag: Media?
    
    let defaults = UserDefaults.standard
    
    init()
    {
        //defaults.removeObject(forKey: "Watchlist")
        let saved_media = defaults.array(forKey: "Watchlist") as? [[String:String]]  ?? []
        for m in saved_media
        {
            if (m.isEmpty) { continue }

            let id = Int(m["id"] ?? "0") ?? 0
            let title = String(m["title"] ?? "")
            let poster = RemoteImage(url: (m["poster"]) ?? "")
            let type = m["type"] ?? ""
            let curr = Media(newId: id, newTitle: title, newPoster: poster, newType: type)
            curr.setKFStr(str: (m["poster"]) ?? "")
            self.operate(item: curr)
        }
    }
    
    public func get_watchlist_str(item: Media) -> String
    {
        for m in watchlist
        {
            if (m.id == item.id) { return "Remove from watchlist" }
        }
        
        return "Add to watchlist"
    }

    public func get_watchlist_img(item: Media) -> String
    {
        for m in watchlist
        {
            if (m.id == item.id) { return "bookmark.fill" }
        }
        
        return "bookmark"
    }
    
    public func get_watchlist_img(id: String) -> String
    {
        for m in watchlist
        {
            if (m.id == Int(id) ?? 0) { return "bookmark.fill" }
        }
        
        return "bookmark"
    }
    
    public func operate(item: Media) -> Bool
    {
        for i in 0..<watchlist.count
        {
            if (watchlist[i].id == item.id)
            {
                watchlist.remove(at: i)
                alterDefaults()
                return false
            }
        }
        watchlist.append(item)
        alterDefaults()
        return true
        
    }
    
    public func alterDefaults()
    {
        var user_array: [[String:String]] = []
        for m in watchlist
        {
            var dict: [String : String] = [:]
            dict["id"] =  String(m.id)
            dict["title"] = m.title
            dict["poster"] = m.kf_str
            dict["type"] = m.type
            user_array.append(dict)
        }
        defaults.set(user_array, forKey: "Watchlist")
    }

}
