//
//  MediaList.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/11/21.
//

import Foundation

public class MediaList: ObservableObject
{
    @Published var list: [Media]
    
    init () {list = []}
    
    func addMedia (newMedia : Media){list.append(newMedia)}
}
