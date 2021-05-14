//
//  DetailView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/13/21.
//

import SwiftUI
import youtube_ios_player_helper

struct DetailView: View
{
    var detailStr: String
    
    @ObservedObject var watchlist: WatchList
    @State var onWatchlistStr: String = "bookmark"
    @State var addedStr: String = "Add to Watchlist"
    @State private var showToast: Bool = false
    
    @State var type: String = "movie"
    @State var typeStr: String = "Recommended Movies"
    @State var expanded: Bool = false
    @State var isLoading = true
    @State var details : Detail = Detail()
    
    @State var recommended: [Media] = []
    
    @State var buttonColor: Color = Color.black
    
    @State var getDetails = true
    {
        didSet
        {
            var sem = 0
            DetailService().get_details(route: detailStr)
            { result in
                details = result!
                self.type = detailStr.contains("movie") ? "movie" : "tv"
                self.typeStr = detailStr.contains("movie") ? "Recommended Movies" : "Recommended TV Shows"
                
                //Set Watchlist On/Off
                onWatchlistStr = watchlist.get_watchlist_img(id: details.id)
                self.buttonColor = (self.onWatchlistStr == "bookmark.fill") ? Color.blue : Color.black
                
                sem += 1
                if (sem == 2) { self.isLoading = false }
            }
            DetailService().get_recs(route: detailStr + "/recommendations")
            {
                recs in
                self.recommended = recs!
                
                sem += 1
                if (sem == 2) { self.isLoading = false }
            }
        }
    }
    
    var body: some View
    {
        if (isLoading)
        {
            LoadingView()
                .onAppear() { self.getDetails = true }
        }
        else
        {
            ScrollView (.vertical)
            {
                VStack (alignment: .leading)
                {
                    Group
                    {
                        if (String(details.trailer) != "")
                        {
                            YTView(id: details.trailer)
                                .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width/2)
                        }
                        
                        Text (details.title)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.bottom, 5)
                        Text (String(details.date) + " | " + details.genres.joined(separator: ", "))
                            .fontWeight(.medium)
                            .font(.system(size: 16))
                            .padding(.bottom, 5)
                            
                        HStack
                        {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.pink)
                            Text (String(details.rating) + "/5.0")
                                .fontWeight(.medium)
                                .font(.system(size: 15))
                        }
                        .padding(.bottom, 5)
                        
                        Text(details.description)
                            .fontWeight(.medium)
                            .font(.system(size: 14))
                            .lineLimit(expanded ? nil : 3)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            
                            
                        Button (action:
                        {
                            expanded.toggle()
                        }, label: {(Text(expanded ? "Show less" : "Show more.."))})
                            .foregroundColor(Color.gray)
                            .font(.system(size: 14))
                            .frame(width: UIScreen.main.bounds.width/1.1, alignment: .trailing)
                            .padding(.bottom, 10)
                            .padding(.trailing, 5)
                    }
                    /* CAST AND CREW */
                    Group
                    {
                        if (details.cast_and_crew.count != 0)
                        {
                            Text ("Cast & Crew")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.bottom, -5)
                        }
                        ScrollView(.horizontal, showsIndicators: true)
                        {
                            HStack
                            {
                                ForEach(details.cast_and_crew)
                                {
                                    person in
                                    VStack
                                    {
                                        person.pic
                                            //.resizable()
                                            .clipShape(Circle())
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width/4)
                                        Text(person.name)
                                            .font(.system(size: 12))
                                            .offset(x: 0, y: -10)
                                    }
                                } /* Cast ForEach */
                            }
                        } /* Cast Scroll View */
                        .padding(.bottom, 10)
                    }
                    
                    /* REVIEWS */
                    Group
                    {
                        if (details.reviews.count != 0)
                        {
                            Text ("Reviews")
                                .fontWeight(.bold)
                                .font(.title)
                        }
                        ForEach(details.reviews)
                        {
                            review in
                            NavigationLink(destination: FullReviewView(aReview: review, media: details.title))
                            {
                                VStack (alignment: .leading)
                                {
                                    Text("A review by " + review.username)
                                        .fontWeight(.bold)
                                        .font(.system(size: 15))
                                        .foregroundColor(.black)
                                        .padding(.leading, 5)
                                        .padding(.top, 5)
                                        .frame(width: UIScreen.main.bounds.width/1.15, alignment: .leading)
                                    Text("Written by " + review.username + " on " + review.date)
                                        .frame(width: UIScreen.main.bounds.width/1.15, alignment: .leading)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray.opacity(0.9))
                                        .padding(.leading, 5)
                                        .padding(.bottom, 1)

                                    HStack
                                    {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(Color.pink)
                                        Text (String(review.rating) + "/5.0")
                                            .font(.system(size: 14))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.leading, 5)
                                    .padding(.bottom, 1)
                                    Text(review.review)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .lineLimit(3)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.leading)
                                        .padding(5)
                                        .padding(.top, 0)
                                        
                                } /* VStack */
                                .frame(minWidth: UIScreen.main.bounds.width/1.1)
                                .padding(.bottom, 3)
                                .overlay(
                                            RoundedRectangle(cornerRadius: 10.0)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                                        )
                            }
                        }
                    }

                    /* RECOMMENDED */
                    Group
                    {
                        if (recommended.count != 0)
                        {
                            Text (self.typeStr)
                                .fontWeight(.bold)
                                .font(.title)
                                .padding(.bottom, -5)
                        }
                        ScrollView(.horizontal, showsIndicators: true)
                        {
                            HStack(alignment: .top)
                            {
                                ForEach(recommended)
                                { aRec in
                                    NavigationLink(destination: DetailView(detailStr: "/" + aRec.type + "/" + String(aRec.id), watchlist: watchlist))
                                    {
                                        ZStack
                                        {
                                            aRec.poster
                                                //.resizable()
                                                .cornerRadius(10)
                                                .clipped()
                                                .scaledToFit()
                                                .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/5)
                                                .padding(.leading, 5)
                                                .padding(.trailing, 20)
                                        } //END OF ZSTACK
                                    }
                                }//END OF FOREACH
                                .frame(height: UIScreen.main.bounds.height/4.7)
                            }
                        }
                    }
                    .padding(0)
                } /* VStack */
                .padding(20)
            } /* Scroll View */
            .toast(isPresented: self.$showToast)
            {
                Text(self.addedStr)
                    .foregroundColor(Color.white)
                    .padding(5)
            } //toast
            .padding(.leading, -1)
            .navigationBarItems(trailing:
                HStack (alignment: .top)
                {
                    Button (action:
                    {
                        let newMedia = Media(newId: Int(details.id) ?? 0, newTitle: details.title, newPoster: details.poster, newType: type)
                        newMedia.setKFStr(str: details.posterStr)
                        self.onWatchlistStr = watchlist.operate(item: newMedia) ? "bookmark.fill" : "bookmark"
                        self.buttonColor = (self.onWatchlistStr == "bookmark.fill") ? Color.blue : Color.black
                        self.addedStr = (self.onWatchlistStr == "bookmark.fill") ? (details.title + " was added to Watchlist") : (details.title + " was removed from Watchlist")
                        
                        if (!self.showToast)
                        {
                            withAnimation {self.showToast = true}
                        }
                    
                    })
                    { Image(systemName: onWatchlistStr) }
                        .foregroundColor(self.buttonColor)
                    
                    Button {
                        let fbShareStr = "https://www.facebook.com/sharer/sharer.php?u=https://themoviedb.org" + self.detailStr
                            guard let url = URL(string: fbShareStr) else { return }
                            UIApplication.shared.open(url)
                    }
                    label:
                    {
                        Image("facebook_logo")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Button {
                        let twitterShareStr = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org" + self.detailStr + "%20%23CSCI571USCFilms"
                        guard let url = URL(string: twitterShareStr) else { return }
                        UIApplication.shared.open(url)}
                    label:
                        {
                            Image("twitter_logo")
                                .resizable()
                                .scaledToFit()
                        }
                }
                .frame(height: UIScreen.main.bounds.height/45)
                                
            )
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(detailStr: "", watchlist: WatchList())
    }
}

struct YTView: UIViewRepresentable
{
    var id: String
    
    func makeUIView(context: Context) -> YTPlayerView
    {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: id, playerVars: ["playsinline" : 1])
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context){}
    
}
