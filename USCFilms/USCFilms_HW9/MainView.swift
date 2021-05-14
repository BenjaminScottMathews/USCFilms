//
//  MainView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/11/21.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var watchList = WatchList()
    @ObservedObject var searchList = SearchList()
    @State private var selection = 2
    
    var body: some View {
        TabView (selection: $selection)
        {
            SearchView(searchResults: searchList, watchlist: watchList)
                .tabItem
                {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            ContentView(watchlist: watchList)
                .tabItem
                {
                    Label("Home", systemImage: "house")
                }
                .tag(2)
            WatchListView(watchList: watchList)
                .tabItem
                {
                    Label("Watchlist", systemImage: "heart")
                }
                .tag(3)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
