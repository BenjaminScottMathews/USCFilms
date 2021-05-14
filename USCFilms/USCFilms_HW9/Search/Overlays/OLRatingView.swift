//
//  OLRatingView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/16/21.
//

import SwiftUI

struct OLRatingView: View
{
    var rating: String
    
    var body: some View
    {
        HStack
        {
            Image(systemName: "star.fill")
                .foregroundColor(Color.pink)
            Text(rating)
                .foregroundColor(Color.white)
                .fontWeight(.bold)
                .font(.system(size: 18))
        }
        .padding()
    }
}

struct OLRatingView_Previews: PreviewProvider {
    static var previews: some View {
        OLRatingView(rating: "5.0")
    }
}
