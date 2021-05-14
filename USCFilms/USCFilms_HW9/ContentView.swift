//
//  ContentView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/9/21.
//

import SwiftUI
import SwiftyJSON
import Combine
import Kingfisher

struct ContentView: View {
    
    @State var carousel_media: [Media] = []
    @State var topRated: [Media] = []
    @State var popular: [Media] = []
    @State var isLoading: Bool = true
    @State var firstOpen: Bool = true
    
    @State private var showToast: Bool = false
    @State private var addedStr: String = ""
    
    @ObservedObject var watchlist: WatchList
    @State var watchlist_str: String = "Add to watchList"
    
    @State var onMovies = true
    {
        didSet
        {
            if (self.onMovies)
            {
                var sem = 0
                GetData().get_carousel(reelType: "/playingMovies")
                    {
                        result in
                        self.carousel_media = result ?? []
                    
                        sem += 1
                        if (sem == 3) { self.isLoading = false }
                    }
                
                GetData().get_toppop(reelType: "/top_movies/movies")
                    {
                        top_rated_results in
                        self.topRated = top_rated_results ?? []
                    
                        sem += 1
                        if (sem == 3) { self.isLoading = false }
                    }
            
                GetData().get_toppop(reelType: "/pop_movies/movies")
                    {
                        pop_results in
                        self.popular = pop_results ?? []
                    
                        sem += 1
                        if (sem == 3) { self.isLoading = false }
                    }
            }
            else
            {
                GetData().get_carousel(reelType: "/airingTV")
                    {
                        result in
                        self.carousel_media = result ?? []
                    }
                
                GetData().get_toppop(reelType: "/top_tv/tv")
                    {
                        top_rated_results in
                        self.topRated = top_rated_results ?? []
                    }
            
                GetData().get_toppop(reelType: "/pop_tv/tv")
                    {
                        pop_results in
                        self.popular = pop_results ?? []
                    }
            }
        }
    }
    @State var currentMediaType = "TV Shows"
    @State var currentTrendingType = "Now Playing"
    
    var body: some View
    {
        
        if isLoading
        {
            LoadingView()
                .onAppear() { onMovies = true; }
                .onDisappear() {firstOpen.toggle()}
        }
        else
        {
            NavigationView
            {
                VStack(alignment: .center)
                {
                    ScrollView
                    {
                        Text(currentTrendingType)
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .offset(x: 0, y: 200)
                            .frame(width: UIScreen.main.bounds.width/1.1, alignment: .leading)
                        GeometryReader
                        { geometry in
                            ImageCarousel(numberOfImages: carousel_media.count)
                            {
                                ForEach(carousel_media)
                                { curr_media in
                                    NavigationLink(destination: DetailView(detailStr: "/" + curr_media.type + "/" + String(curr_media.id), watchlist: watchlist))
                                    {
                                        ZStack
                                        {
                                            curr_media.poster
                                            //.resizable()
                                            .scaledToFill()
                                            .blur(radius: 20.0)
                                            .frame(width: abs(geometry.size.width-30), height: geometry.size.height)
                                            .clipped()
                                            curr_media.poster
                                            //.resizable()
                                            .scaledToFit()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .clipped()
                                        }
                                    }
                                } //END OF FOREACH
                            } //END OF IMAGE CAROUSEL
                        }.frame(height: 300, alignment: .center)
                         .offset(x: 0, y: 200)
                        
                        //TopMovie Reel
                        Text("Top Rated")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .offset(x: -125, y:200)
                        
                        ScrollView(.horizontal, showsIndicators: true)
                        {
                            HStack(alignment: .firstTextBaseline, spacing: 30)
                            {
                                ForEach(topRated)
                                { curr_top in
                                    NavigationLink(destination: DetailView(detailStr: "/" + curr_top.type + "/" + String(curr_top.id), watchlist: watchlist))
                                    {
                                        ReelView(curr: curr_top, watchlist: watchlist)
                                            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .contextMenu
                                            {
                                                Button
                                                {
                                                    self.addedStr = watchlist.operate(item: curr_top) ? (curr_top.title + " was added to Watchlist") : (curr_top.title + " was removed from Watchlist")
                                                    
                                                    if (!self.showToast)
                                                    {
                                                        withAnimation {self.showToast = true}
                                                    }
                                                }
                                                label: { Label(watchlist.get_watchlist_str(item: curr_top), systemImage: watchlist.get_watchlist_img(item: curr_top))}
                                
                                                Button {
                                                    let fbShareStr = "https://www.facebook.com/sharer/sharer.php?u=https://themoviedb.org/" + curr_top.type + "/" + String(curr_top.id)
                                                        guard let url = URL(string: fbShareStr) else { return }
                                                        UIApplication.shared.open(url)
                                                }
                                                label: { Label("Share on Facebook", image: "facebook_logo") }
                                                
                                                
                                                Button {
                                                    let twitterShareStr = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/" + curr_top.type + "/" + String(curr_top.id) + "%20%23CSCI571USCFilms"
                                                    guard let url = URL(string: twitterShareStr) else { return }
                                                    UIApplication.shared.open(url)}
                                                label: { Label("Share on Twitter", image: "twitter_logo") }
                                            }
                                            
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                   
                                }//END OF FOREACH
                            }
                            .padding(10)
                        }
                        .offset(x: 0, y: 190)
                        .padding(.bottom, 60)
                        
                        Text("Popular")
                            .fontWeight(.bold)
                            .font(.system(size: 24))
                            .offset(x: -135, y:130)
                        
                        //Popular Reel
                        ScrollView(.horizontal, showsIndicators: true)
                        {
                            HStack(alignment: .firstTextBaseline, spacing: 30)
                            {
                                ForEach(popular)
                                { curr_pop in
                                    NavigationLink(destination: DetailView(detailStr: "/" + curr_pop.type + "/" + String(curr_pop.id), watchlist: watchlist))
                                    {
                                        ReelView(curr: curr_pop, watchlist: watchlist)
                                            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .contextMenu
                                            {
                                                Button
                                                {
                                                    self.addedStr = watchlist.operate(item: curr_pop) ? (curr_pop.title + " was added to Watchlist") : (curr_pop.title + " was removed from Watchlist")
                                                    
                                                    if (!self.showToast)
                                                    {
                                                        withAnimation {self.showToast = true}
                                                    }
                                                }
                                                label: { Label(watchlist.get_watchlist_str(item: curr_pop), systemImage: watchlist.get_watchlist_img(item: curr_pop))}
                                
                                                Button {
                                                    let fbShareStr = "https://www.facebook.com/sharer/sharer.php?u=https://themoviedb.org/" + curr_pop.type + "/" + String(curr_pop.id)
                                                        guard let url = URL(string: fbShareStr) else { return }
                                                        UIApplication.shared.open(url)
                                                }
                                                label: { Label("Share on Facebook", image: "facebook_logo") }
                                                
                                                
                                                Button {
                                                    let twitterShareStr = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/" + curr_pop.type + "/" + String(curr_pop.id) + "%20%23CSCI571USCFilms"
                                                    guard let url = URL(string: twitterShareStr) else { return }
                                                    UIApplication.shared.open(url)}
                                                label: { Label("Share on Twitter", image: "twitter_logo") }
                                            }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                   
                                }//END OF FOREACH
                            }
                            .padding(10)
                        }
                        .cornerRadius(10)
                        .offset(x: 0, y: 120)
                        
                        VStack (alignment: .center)
                        {
                            Button {
                                guard let url = URL(string: "https://themoviedb.org") else { return }
                                UIApplication.shared.open(url)
                            } label: { Text("Powered by TMDB")
                                            .font(.system(size: 13))
                            }
                            Text("Developed by Ben Mathews")
                                .font(.system(size: 13))
                        }
                        .foregroundColor(.gray)
                        .offset(x:0, y:130)
                        .frame(width: UIScreen.main.bounds.width, height: 180, alignment: .top)
                        
                    } //END OF MAIN SCROLL VIEW
                    .toast(isPresented: self.$showToast)
                    {
                        Text(self.addedStr)
                            .foregroundColor(Color.white)
                            .padding(5)
                    } //toast
                    .offset(x: 0, y: -60)
                    
                } //END OF VSTACK
               
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle(Text("USC Films"))
                .navigationBarItems(trailing:
                                Button(action: {
                                    onMovies.toggle()
                                    self.currentMediaType = MediaType().getType(onMovies: onMovies)
                                    self.currentTrendingType = MediaType().getType2(onMovies: onMovies)
                                }) {
                                    Text(currentMediaType)
                                })
            }//NAVVIEW
            
        }
    }//VIEW
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(watchlist: WatchList())
    }
}

struct LoadingView: View
{
    var body: some View
    {
        ZStack
        {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
            Text ("Fetching Data")
                .opacity(0.4)
                .offset(x: 0, y: 40)
        }
        
    }
}

