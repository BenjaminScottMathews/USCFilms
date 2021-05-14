//
//  ReelView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/18/21.
//

import SwiftUI

struct ReelView: View
{
    var curr: Media
    
    @ObservedObject var watchlist: WatchList
    
    var body: some View
    {
        VStack
        {
            curr.poster
                //.resizable()
                //.clipped()
                .scaledToFill()
                .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .cornerRadius(10)
                .frame(width: 100, height: 150);
            Text(curr.title)
                .fontWeight(.bold)
                .font(.caption)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(10)
            Text("(" + curr.date + ")")
                .font(.caption)
                .foregroundColor(.gray)
               
        }
        .background(Color.white)
        .cornerRadius(10)
        .frame(width: UIScreen.main.bounds.width/4, alignment: .top)
    }
    
    
    
}

struct ReelView_Previews: PreviewProvider {
    static var previews: some View {
        ReelView(curr: Media(), watchlist: WatchList())
    }
}

