//
//  FullReviewView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/15/21.
//

import SwiftUI

struct FullReviewView: View {
    
    var aReview: Review
    var media: String
    
    var body: some View {
        ScrollView
        {
            VStack (alignment: .leading)
            {
                Text(media)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                Text("By " + aReview.username + " on " + aReview.date)
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 5)
                HStack
                {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.pink)
                    Text (String(aReview.rating) + "/5.0")
                }
                Divider()
                Text(aReview.review)
            }
            .padding(20)
        }
    }
}

struct FullReviewView_Previews: PreviewProvider {
    static var previews: some View {
        FullReviewView(aReview: Review(), media: "Ben's Preview Movie")
    }
}
