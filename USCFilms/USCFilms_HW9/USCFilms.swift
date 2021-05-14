//
//  USCFilms.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/12/21.
//

import SwiftUI

struct uscFilms: App
{
    @StateObject var watchlist = WatchList()
    
    var body: some Scene
    {
        WindowGroup
        {
            MainView()
                .environmentObject(watchlist)
        }
    }
}
