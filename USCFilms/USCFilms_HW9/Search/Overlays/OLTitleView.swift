//
//  OLTitleView.swift
//  USCFilms_HW9
//
//  Created by Benjamin Mathews on 4/16/21.
//

import SwiftUI

struct OLTitleView: View
{
    var title: String
    
    var body: some View
    {
        Text(title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .font(.system(size: 19))
            .padding()
    }
}

struct OLTitleView_Previews: PreviewProvider {
    static var previews: some View {
        OLTitleView(title: "Placeholder")
    }
}
