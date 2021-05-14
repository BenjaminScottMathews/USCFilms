//
//  WatchListView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/12/21.
//

import SwiftUI
import Combine

struct WatchListView: View {
    
    @ObservedObject var watchList: WatchList
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 3)
    
    var body: some View {
        if (watchList.watchlist.count == 0)
        {
            Text ("Watchlist is empty")
                .font(.system(size: 22))
                .opacity(0.4)
        }
        else
        {
            NavigationView
            {
                ScrollView
                {
                    LazyVGrid(columns: columns, spacing: 3)
                    {
                        
                        ForEach(watchList.watchlist)
                        { current_media in
                            
                                VStack
                                {
                                    NavigationLink(destination: DetailView(detailStr: "/" + current_media.type + "/" + String(current_media.id), watchlist: watchList))
                                    {
                                        current_media.poster
                                            //.resizable()
                                            .opacity(watchList.currentDrag?.id == current_media.id ? 0.01 : 1.0)
                                            .clipped()
                                            .scaledToFit()
                                            .onDrag(
                                                {
                                                        watchList.currentDrag = current_media
                                                        
                                                        return NSItemProvider(object: String(current_media.id) as NSString)
                                                
                                                })
                                            .onDrop(of: [current_media.title], delegate: DropViewDelegate(med: current_media, mediaData: watchList))
                                            .contextMenu
                                            {
                                                Button
                                                { watchList.operate(item: current_media) }
                                                label: { Label("Remove from watchlist", systemImage: "bookmark.fill")}
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                          
                                            
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                   
                                    
                                }
                               
                                
                            
                            
                        }
                    } /* HStack */
                    .padding(.horizontal)
                    .navigationBarTitle(Text("Watchlist"))
                }
            }
        }
    }
}

struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView(watchList: WatchList())
    }
}
